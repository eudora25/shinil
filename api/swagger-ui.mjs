// Swagger UI API 엔드포인트 (IP 차단 적용)
import { config } from 'dotenv'
import path from 'path'
import { fileURLToPath } from 'url'
import fs from 'fs'

const __filename = fileURLToPath(import.meta.url)
const __dirname = path.dirname(__filename)

// 환경 변수 로드
const nodeEnv = process.env.NODE_ENV || 'development'
const envFile = nodeEnv === 'production' ? '.env.production' : '.env.local'

try {
  config({ 
    path: path.join(__dirname, '..', envFile),
    override: true
  })
  console.log(`✅ 환경 파일 로드 성공: ${envFile}`)
} catch (error) {
  console.log(`⚠️ 환경 파일 로드 실패: ${envFile} - 런타임 환경 변수 사용`)
}

// IP 제한 함수
function checkIPAccess(req) {
  // 개발 환경에서는 모든 IP 허용
  if (process.env.NODE_ENV === 'development' || !process.env.NODE_ENV) {
    console.log('🔓 개발 환경: 모든 IP 허용')
    return { allowed: true }
  }

    // 환경 변수에서 허용된 IP 목록 로드
  const envIPs = process.env.ALLOWED_IPS
  if (!envIPs) {
    console.log('❌ ALLOWED_IPS 환경 변수가 설정되지 않았습니다')
    return { 
      allowed: false, 
      error: {
        success: false,
        message: 'IP 접근 제한 설정이 올바르지 않습니다.',
        error: 'IP_CONFIG_ERROR',
        timestamp: new Date().toISOString()
      }
    }
  }

  const allowedIPs = envIPs.split(',').map(ip => ip.trim()).filter(ip => ip.length > 0)

  // 클라이언트 IP 확인
  const clientIP = req.headers['x-forwarded-for']?.split(',')[0]?.trim() ||
                   req.headers['x-real-ip'] ||
                   req.connection?.remoteAddress ||
                   req.socket?.remoteAddress ||
                   req.ip ||
                   '127.0.0.1'

  console.log('🔍 클라이언트 IP 확인:', clientIP)
  console.log('🔒 허용된 IP 목록:', allowedIPs.join(', '))

  // IP 허용 여부 확인
  const isAllowed = allowedIPs.some(allowedIP => {
    // 정확한 IP 매칭
    if (allowedIP === clientIP) return true
    
    // IPv4-mapped IPv6 주소 처리 (::ffff:192.168.65.1 -> 192.168.65.1)
    if (clientIP.startsWith('::ffff:')) {
      const ipv4Part = clientIP.substring(7) // ::ffff: 제거
      if (allowedIP === ipv4Part) return true
    }
    
    // IPv4 주소를 IPv4-mapped IPv6로 변환해서 매칭
    if (allowedIP.includes('.') && !allowedIP.includes(':')) {
      const mappedIPv6 = `::ffff:${allowedIP}`
      if (clientIP === mappedIPv6) return true
    }
    
    // CIDR 표기법 지원 (예: 192.168.1.0/24)
    if (allowedIP.includes('/')) {
      const [network, bits] = allowedIP.split('/')
      const mask = ~((1 << (32 - parseInt(bits))) - 1)
      const networkLong = ipToLong(network) & mask
      const ipLong = ipToLong(clientIP) & mask
      return networkLong === ipLong
    }
    
    return false
  })

  if (!isAllowed) {
    console.log('🚫 IP 접근 차단:', clientIP)
    return { 
      allowed: false, 
      error: {
        success: false,
        message: '접근이 허용되지 않은 IP입니다.',
        error: 'IP_ACCESS_DENIED',
        clientIP: clientIP,
        timestamp: new Date().toISOString()
      }
    }
  }

  console.log('✅ IP 접근 허용:', clientIP)
  return { allowed: true }
}

// IP 주소를 long으로 변환
function ipToLong(ip) {
  return ip.split('.').reduce((acc, octet) => (acc << 8) + parseInt(octet), 0) >>> 0
}

export default async function handler(req, res) {
  try {
    // IP 접근 권한 확인
    const ipCheck = checkIPAccess(req)
    if (!ipCheck.allowed) {
      return res.status(403).json(ipCheck.error)
    }

    // Swagger UI HTML 생성
    const swaggerUIHtml = `<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>신일 프로젝트 API 문서</title>
    <link rel="stylesheet" type="text/css" href="https://unpkg.com/swagger-ui-dist@5.9.0/swagger-ui.css" />
    <style>
        html {
            box-sizing: border-box;
            overflow: -moz-scrollbars-vertical;
            overflow-y: scroll;
        }
        *, *:before, *:after {
            box-sizing: inherit;
        }
        body {
            margin:0;
            background: #fafafa;
        }
        .swagger-ui .topbar {
            background-color: #2c3e50;
        }
        .swagger-ui .topbar .download-url-wrapper {
            display: none;
        }
    </style>
</head>
<body>
    <div id="swagger-ui"></div>
    <script src="https://unpkg.com/swagger-ui-dist@5.9.0/swagger-ui-bundle.js"></script>
    <script src="https://unpkg.com/swagger-ui-dist@5.9.0/swagger-ui-standalone-preset.js"></script>
    <script>
        window.onload = function() {
            // swagger-spec.json 파일을 직접 로드
            fetch('/api/swagger-spec')
                .then(response => {
                    if (!response.ok) {
                        throw new Error('Failed to load swagger spec');
                    }
                    return response.json();
                })
                .then(spec => {
                    const ui = SwaggerUIBundle({
                        spec: spec,
                        dom_id: '#swagger-ui',
                        deepLinking: true,
                        presets: [
                            SwaggerUIBundle.presets.apis,
                            SwaggerUIStandalonePreset
                        ],
                        plugins: [
                            SwaggerUIBundle.plugins.DownloadUrl
                        ],
                        layout: "StandaloneLayout",
                        validatorUrl: null,
                        tryItOutEnabled: true,
                        requestInterceptor: (request) => {
                            // 모든 API 요청에 Authorization 헤더 추가 (토큰이 있는 경우)
                            const token = localStorage.getItem('authToken');
                            if (token) {
                                request.headers.Authorization = \`Bearer \${token}\`;
                            }
                            return request;
                        },
                        responseInterceptor: (response) => {
                            // 응답에서 토큰 저장
                            if (response.body && response.body.data && response.body.data.session) {
                                localStorage.setItem('authToken', response.body.data.session.access_token);
                            }
                            return response;
                        }
                    });
                })
                .catch(error => {
                    console.error('Error loading Swagger spec:', error);
                    document.getElementById('swagger-ui').innerHTML = 
                        '<div style="padding: 20px; text-align: center;">' +
                        '<h2>API 문서를 불러올 수 없습니다</h2>' +
                        '<p>서버에 연결할 수 없습니다. 잠시 후 다시 시도해주세요.</p>' +
                        '</div>';
                });
        };
    </script>
</body>
</html>`

    // HTML 응답
    res.setHeader('Content-Type', 'text/html; charset=utf-8')
    res.status(200).send(swaggerUIHtml)

  } catch (error) {
    console.error('Swagger UI API error:', error)
    return res.status(500).json({
      success: false,
      message: 'Swagger UI를 불러오는 중 오류가 발생했습니다.',
      error: error.message
    })
  }
}
