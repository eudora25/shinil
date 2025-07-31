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
        // 제품 목록 조회
        const { data: products, error: getError } = await supabase
          .from('products')
          .select('*')
          .order('created_at', { ascending: false })

        if (getError) throw getError

        return res.status(200).json({
          success: true,
          message: '제품 목록 조회 성공',
          data: products
        })

      case 'POST':
        // 새 제품 등록
        const { 
          product_name, 
          insurance_code, 
          drug_price, 
          commission_rate,
          manufacturer,
          description 
        } = req.body

        if (!product_name || !insurance_code || !drug_price) {
          return res.status(400).json({
            success: false,
            message: '제품명, 보험코드, 약가는 필수입니다.'
          })
        }

        const { data: newProduct, error: postError } = await supabase
          .from('products')
          .insert([{
            product_name,
            insurance_code,
            drug_price: parseFloat(drug_price),
            commission_rate: commission_rate ? parseFloat(commission_rate) : 0,
            manufacturer,
            description,
            is_active: true
          }])
          .select()

        if (postError) throw postError

        return res.status(201).json({
          success: true,
          message: '제품 등록 성공',
          data: newProduct[0]
        })

      default:
        return res.status(405).json({
          success: false,
          message: 'Method not allowed'
        })
    }
  } catch (error) {
    console.error('Products API error:', error)
    return res.status(500).json({
      success: false,
      message: '서버 오류가 발생했습니다.',
      error: error.message
    })
  }
} 