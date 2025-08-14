// CommonJS 형식으로 변경 (Vercel 호환성 테스트)
const handler = (req, res) => {
  res.setHeader('Access-Control-Allow-Origin', '*')
  res.setHeader('Content-Type', 'application/json')
  
  return res.status(200).json({
    success: true,
    message: 'Simple API is working',
    timestamp: new Date().toISOString(),
    method: req.method
  })
}

module.exports = handler
