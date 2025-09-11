// Vercel 서버리스 함수 형식으로 API 루트 엔드포인트 생성
export default async function handler(req, res) {
  try {
    // API 루트 엔드포인트 (01_API_상태확인.xlsx 형식에 맞춤)
    res.json({
      name: 'Shinil PMS API Server',
      version: '1.0.0',
      status: 'running',
      timestamp: new Date().toISOString(),
      environment: 'production'
    })
  } catch (error) {
    console.error('API root endpoint error:', error)
    res.status(500).json({
      error: {
        code: '500',
        message: 'A server error has occurred'
      }
    })
  }
}