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
    
    console.log(`🔒 Swagger spec 접근 시도: ${clientIP}`)
    
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
    
    // Swagger spec JSON 반환
    const swaggerSpec = {
      "openapi": "3.0.3",
      "info": {
        "title": "신일 프로젝트 API (IP 제한됨)",
        "description": "신일 프로젝트의 REST API 문서입니다. IP 제한이 적용되어 있습니다.",
        "version": "2.2.0",
        "contact": {
          "name": "신일 프로젝트 개발팀",
          "email": "dev@shinil.com"
        },
        "license": {
          "name": "MIT",
          "url": "https://opensource.org/licenses/MIT"
        }
      },
      "servers": [
        {
          "url": "http://localhost:3001/api",
          "description": "로컬 API 서버 (개발용)"
        },
        {
          "url": "/api",
          "description": "현재 도메인 API 서버 (프로덕션)"
        },
        {
          "url": "https://shinil-project.vercel.app/api",
          "description": "Vercel 프로덕션 서버"
        }
      ],
      "tags": [
        {
          "name": "인증",
          "description": "사용자 인증 관련 API"
        },
        {
          "name": "시스템",
          "description": "시스템 상태 확인 API"
        },
        {
          "name": "기본 정보",
          "description": "회원정보, 제품정보, 병원정보, 약국정보, 고객정보 조회"
        },
        {
          "name": "공지사항",
          "description": "공지사항 조회"
        }
      ],
      "paths": {
        "/": {
          "get": {
            "tags": ["시스템"],
            "summary": "API 상태 확인",
            "description": "API 서버의 기본 상태를 확인합니다.",
            "responses": {
              "200": {
                "description": "성공적으로 API 상태를 반환",
                "content": {
                  "application/json": {
                    "schema": {
                      "type": "object",
                      "properties": {
                        "name": {
                          "type": "string",
                          "example": "Shinil PMS API"
                        },
                        "version": {
                          "type": "string",
                          "example": "1.0.0"
                        },
                        "status": {
                          "type": "string",
                          "example": "running"
                        },
                        "timestamp": {
                          "type": "string",
                          "format": "date-time",
                          "example": "2024-01-01T00:00:00.000Z"
                        },
                        "environment": {
                          "type": "string",
                          "example": "production"
                        }
                      }
                    }
                  }
                }
              }
            }
          }
        }
      },
      "components": {
        "securitySchemes": {
          "bearerAuth": {
            "type": "http",
            "scheme": "bearer",
            "bearerFormat": "JWT",
            "description": "JWT 토큰을 입력하세요. 'Bearer ' 접두사는 자동으로 추가됩니다."
          }
        },
        "schemas": {
          "Error": {
            "type": "object",
            "properties": {
              "success": {
                "type": "boolean",
                "example": false
              },
              "message": {
                "type": "string",
                "description": "오류 메시지"
              },
              "error": {
                "type": "string",
                "description": "상세 오류 정보"
              }
            }
          }
        }
      }
    }
    
    return new Response(JSON.stringify(swaggerSpec, null, 2), {
      headers: {
        ...headers,
        'Content-Type': 'application/json'
      }
    })
    
  } catch (error) {
    console.error('Swagger spec 접근 오류:', error)
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
