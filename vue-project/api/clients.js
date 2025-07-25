export default function handler(req, res) {
  res.setHeader('Content-Type', 'application/json')
  res.status(200).json({
    test: "003",
    message: "Clients API endpoint",
    timestamp: new Date().toISOString(),
    data: []
  })
} 