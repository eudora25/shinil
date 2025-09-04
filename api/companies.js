module.exports = function handler(req, res) {
  res.status(200).json({
    success: true,
    message: 'Test API working',
    data: [],
    count: 0,
    page: 1,
    limit: 100
  })
}