import { serve } from "https://deno.land/std@0.168.0/http/server.ts"

// 허용된 IP 주소 목록
const ALLOWED_IPS = [
  '127.0.0.1',        // localhost
  '::1',              // localhost IPv6
  '192.168.1.100',    // 예시: 허용할 IP 주소
  '203.241.xxx.xxx'   // 예시: 허용할 IP 주소 (실제 IP로 변경 필요)
]

// IP 주소를 long으로 변환하는 함수
function ipToLong(ip: string): number {
  return ip.split('.').reduce((acc, octet) => (acc << 8) + parseInt(octet), 0) >>> 0
}

// IP 접근 권한 확인 함수
function isIPAllowed(clientIP: string): boolean {
  return ALLOWED_IPS.some(allowedIP => {
    // 정확한 IP 매칭
    if (allowedIP === clientIP) return true
    
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
}

serve(async (req) => {
  // CORS 헤더 설정
  const headers = {
    'Access-Control-Allow-Origin': '*',
    'Access-Control-Allow-Headers': 'authorization, x-client-info, apikey, content-type',
    'Access-Control-Allow-Methods': 'GET, POST, PUT, DELETE, OPTIONS',
  }

  // OPTIONS 요청 처리 (CORS preflight)
  if (req.method === 'OPTIONS') {
    return new Response(null, { headers })
  }

  try {
    // 클라이언트 IP 주소 확인
    const clientIP = req.headers.get('x-forwarded-for')?.split(',')[0]?.trim() || 
                    req.headers.get('x-real-ip') || 
                    'unknown'
    
    console.log(`🔒 Swagger 접근 시도: ${clientIP}`)
    
    // IP 접근 권한 확인
    if (!isIPAllowed(clientIP)) {
      console.log(`❌ 접근 거부: ${clientIP}`)
      return new Response(
        JSON.stringify({
          success: false,
          message: '접근이 거부되었습니다. 허용된 IP에서만 접근 가능합니다.',
          error: 'IP_ACCESS_DENIED',
          clientIP: clientIP
        }),
        {
          status: 403,
          headers: {
            ...headers,
            'Content-Type': 'application/json'
          }
        }
      )
    }
    
    console.log(`✅ 접근 허용: ${clientIP}`)
    
    // Swagger UI HTML 반환
    const swaggerHTML = `<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>신일 프로젝트 API 문서 (IP 제한됨)</title>
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
        .access-info {
            background: #e8f5e8;
            border: 1px solid #4caf50;
            padding: 10px;
            margin: 10px;
            border-radius: 4px;
            text-align: center;
        }
    </style>
</head>
<body>
    <div class="access-info">
        ✅ 허용된 IP에서 접근 중: ${clientIP}
    </div>
    <div id="swagger-ui"></div>
    <script src="https://unpkg.com/swagger-ui-dist@5.9.0/swagger-ui-bundle.js"></script>
    <script src="https://unpkg.com/swagger-ui-dist@5.9.0/swagger-ui-standalone-preset.js"></script>
    <script>
        window.onload = function() {
            const ui = SwaggerUIBundle({
                url: '/api/swagger-spec',
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
                docExpansion: 'list',
                filter: true,
                showRequestHeaders: true,
                showCommonExtensions: true,
                supportedSubmitMethods: ['get', 'post', 'put', 'delete', 'patch'],
                tryItOutEnabled: true
            });
        };
    </script>
</body>
</html>`
    
    return new Response(swaggerHTML, {
      headers: {
        ...headers,
        'Content-Type': 'text/html; charset=utf-8'
      }
    })
    
  } catch (error) {
    console.error('Swagger 접근 오류:', error)
    return new Response(
      JSON.stringify({
        success: false,
        message: '서버 오류가 발생했습니다.',
        error: error.message
      }),
      {
        status: 500,
        headers: {
          ...headers,
          'Content-Type': 'application/json'
        }
      }
    )
  }
})
