export default function handler(req, res) {
  res.setHeader('Content-Type', 'application/json')
  res.status(200).json({
    test: "001",
    status: "OK",
    timestamp: new Date().toISOString(),
    version: "1.0.0",
    environment: "production"
  })
} 