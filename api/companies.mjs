export default async function handler(req, res) {
  res.json({
    success: true,
    message: 'Test API working',
    data: [],
    count: 0,
    page: 1,
    limit: 100
  })
}