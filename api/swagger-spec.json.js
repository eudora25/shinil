export default async function handler(req, res) {
  // Vercel 환경에 맞게 인라인으로 API 명세 작성
  const swaggerSpec = {
    "openapi": "3.0.3",
    "info": {
      "title": "신일 프로젝트 API",
      "description": "신일 프로젝트의 REST API 문서입니다. 기본 정보, 인증, 공지사항, 실적관리, 정산관리 등의 기능을 제공합니다.",
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
        "url": "https://shinil.vercel.app/api",
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
        "description": "회원정보, 제품정보, 병원정보, 약국정보, 병원정보 조회"
      },
      {
        "name": "관계 정보",
        "description": "병원-업체, 병원-약국, 제품-업체 관계 정보 조회"
      },
      {
        "name": "매출 관리",
        "description": "도매 매출, 직매 매출 정보 관리"
      },
      {
        "name": "공지사항",
        "description": "공지사항 조회"
      },
      {
        "name": "실적 관리",
        "description": "실적 정보, 흡수율, 증빙 파일 관리"
      },
      {
        "name": "정산 관리",
        "description": "정산월, 정산내역서, 매출 정보 관리"
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
                        "example": "Sinil PMS API"
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
                        "example": "development"
                      }
                    }
                  }
                }
              }
            }
          }
        }
      },
      "/auth/login": {
        "post": {
          "tags": ["인증"],
          "summary": "사용자 로그인",
          "description": "이메일과 비밀번호로 사용자 인증을 수행합니다",
          "requestBody": {
            "required": true,
            "content": {
              "application/json": {
                "schema": {
                  "type": "object",
                  "properties": {
                    "email": {"type": "string", "format": "email"},
                    "password": {"type": "string"}
                  },
                  "required": ["email", "password"]
                }
              }
            }
          },
          "responses": {
            "200": {
              "description": "로그인 성공",
              "content": {
                "application/json": {
                  "schema": {
                    "type": "object",
                    "properties": {
                      "success": {"type": "boolean"},
                      "token": {"type": "string"},
                      "user": {"type": "object"}
                    }
                  }
                }
              }
            },
            "401": {
              "description": "인증 실패"
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
          "bearerFormat": "JWT"
        }
      }
    }
  }

  res.setHeader('Content-Type', 'application/json')
  res.setHeader('Cache-Control', 'no-cache, no-store, must-revalidate')
  res.setHeader('Pragma', 'no-cache')
  res.setHeader('Expires', '0')
  res.status(200).json(swaggerSpec)
}
