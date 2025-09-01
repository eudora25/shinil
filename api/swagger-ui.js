import fs from 'fs'
import path from 'path'
import { fileURLToPath } from 'url'

const __filename = fileURLToPath(import.meta.url)
const __dirname = path.dirname(__filename)

export default async function handler(req, res) {
  res.setHeader('Access-Control-Allow-Origin', '*')
  res.setHeader('Access-Control-Allow-Methods', 'GET, OPTIONS')
  res.setHeader('Access-Control-Allow-Headers', 'Content-Type')

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
    const swaggerUiContent = fs.readFileSync(swaggerUiPath, 'utf8')
    
    res.setHeader('Content-Type', 'text/html')
    res.status(200).send(swaggerUiContent)
  } catch (error) {
    console.error('Swagger UI error:', error)
    res.status(500).json({ error: 'Failed to load Swagger UI' })
  }
}
