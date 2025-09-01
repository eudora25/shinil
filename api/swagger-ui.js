import fs from 'fs'
import path from 'path'
import { fileURLToPath } from 'url'

const __filename = fileURLToPath(import.meta.url)
const __dirname = path.dirname(__filename)

export default async function handler(req, res) {
  // CORS 헤더 설정
  res.setHeader('Access-Control-Allow-Origin', '*')
  res.setHeader('Access-Control-Allow-Methods', 'GET, OPTIONS')
  res.setHeader('Access-Control-Allow-Headers', 'Content-Type')
  res.setHeader('Cache-Control', 'no-cache, no-store, must-revalidate')
  res.setHeader('Pragma', 'no-cache')
  res.setHeader('Expires', '0')

  if (req.method === 'OPTIONS') {
    res.status(200).end()
    return
  }

  if (req.method !== 'GET') {
    return res.status(405).json({ error: 'Method not allowed' })
  }

  try {
    // Swagger UI HTML 파일 읽기
    const swaggerUiPath = path.join(__dirname, '../swagger-ui.html')
    
    if (!fs.existsSync(swaggerUiPath)) {
      console.error('Swagger UI file not found:', swaggerUiPath)
      return res.status(404).json({ error: 'Swagger UI file not found' })
    }
    
    const swaggerUiContent = fs.readFileSync(swaggerUiPath, 'utf8')
    
    res.setHeader('Content-Type', 'text/html; charset=utf-8')
    res.status(200).send(swaggerUiContent)
  } catch (error) {
    console.error('Swagger UI error:', error)
    res.status(500).json({ 
      error: 'Failed to load Swagger UI',
      details: error.message 
    })
  }
}
