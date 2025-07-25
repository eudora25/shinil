export default function handler(req, res) {
  res.setHeader('Content-Type', 'application/json')
  res.status(200).json({
    test: "002",
    message: "Products API endpoint",
    timestamp: new Date().toISOString(),
    data: []
  })
} 