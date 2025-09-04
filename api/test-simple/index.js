export default function handler(req, res) {
  console.log('=== Simple Test API 호출됨 ===')
  console.log('Method:', req.method)
  console.log('URL:', req.url)
  
  res.status(200).json({
    success: true,
    message: 'Simple test API is working!',
    method: req.method,
    url: req.url,
    timestamp: new Date().toISOString()
  })
}
