import { createClient } from '@supabase/supabase-js'

const supabaseUrl = process.env.VITE_SUPABASE_URL
const supabaseAnonKey = process.env.VITE_SUPABASE_ANON_KEY

const supabase = createClient(supabaseUrl, supabaseAnonKey)

export default async function handler(req, res) {
  // CORS 헤더 설정
  res.setHeader('Access-Control-Allow-Origin', '*')
  res.setHeader('Access-Control-Allow-Methods', 'GET, POST, PUT, DELETE, OPTIONS')
  res.setHeader('Access-Control-Allow-Headers', 'Content-Type, Authorization')
  res.setHeader('Content-Type', 'application/json')
  
  // OPTIONS 요청 처리
  if (req.method === 'OPTIONS') {
    res.status(200).end()
    return
  }

  try {
    switch (req.method) {
      case 'GET':
        // 도매매출 목록 조회
        const { data: wholesaleSales, error: getError } = await supabase
          .from('wholesale_sales')
          .select('*')
          .order('created_at', { ascending: false })

        if (getError) throw getError

        return res.status(200).json({
          success: true,
          message: '도매매출 목록 조회 성공',
          data: wholesaleSales
        })

      case 'POST':
        // 새 도매매출 등록
        const { 
          pharmacy_name, 
          business_number, 
          address, 
          sales_amount,
          sales_date,
          product_id 
        } = req.body

        if (!pharmacy_name || !business_number || !sales_amount) {
          return res.status(400).json({
            success: false,
            message: '약국명, 사업자등록번호, 매출액은 필수입니다.'
          })
        }

        const { data: newWholesaleSale, error: postError } = await supabase
          .from('wholesale_sales')
          .insert([{
            pharmacy_name,
            business_number,
            address,
            sales_amount: parseFloat(sales_amount),
            sales_date,
            product_id
          }])
          .select()

        if (postError) throw postError

        return res.status(201).json({
          success: true,
          message: '도매매출 등록 성공',
          data: newWholesaleSale[0]
        })

      default:
        return res.status(405).json({
          success: false,
          message: 'Method not allowed'
        })
    }
  } catch (error) {
    console.error('Wholesale sales API error:', error)
    return res.status(500).json({
      success: false,
      message: '서버 오류가 발생했습니다.',
      error: error.message
    })
  }
} 