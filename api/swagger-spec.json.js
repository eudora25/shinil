export default async function handler(req, res) {
  // 루트의 swagger-spec.json 파일을 읽어서 반환
  const fs = require('fs');
  const path = require('path');
  
  try {
    const swaggerSpecPath = path.join(process.cwd(), 'swagger-spec.json');
    const swaggerSpec = JSON.parse(fs.readFileSync(swaggerSpecPath, 'utf8'));
    
    res.setHeader('Content-Type', 'application/json')
    res.setHeader('Cache-Control', 'no-cache, no-store, must-revalidate')
    res.setHeader('Pragma', 'no-cache')
    res.setHeader('Expires', '0')
    res.status(200).json(swaggerSpec)
  } catch (error) {
    res.status(500).json({ error: 'Failed to load swagger spec' })
  }
}
