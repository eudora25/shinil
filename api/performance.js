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
        // 실적 목록 조회
        const { data: performances, error: getError } = await supabase
          .from('performance_records')
          .select(`
            *,
            companies (company_name),
            hospitals (hospital_name),
            products (product_name, insurance_code)
          `)
          .order('created_at', { ascending: false })

        if (getError) throw getError

        return res.status(200).json({
          success: true,
          message: '실적 목록 조회 성공',
          data: performances
        })

      case 'POST':
        // 새 실적 등록
        const { 
          company_id, 
          hospital_id, 
          product_id, 
          prescription_count,
          settlement_month,
          notes 
        } = req.body

        if (!company_id || !hospital_id || !product_id || !settlement_month) {
          return res.status(400).json({
            success: false,
            message: '회원 ID, 병원 ID, 제품 ID, 정산월은 필수입니다.'
          })
        }

        const { data: newPerformance, error: postError } = await supabase
          .from('performance_records')
          .insert([{
            company_id,
            hospital_id,
            product_id,
            prescription_count: prescription_count ? parseInt(prescription_count) : 0,
            settlement_month,
            notes,
            status: 'pending'
          }])
          .select()

        if (postError) throw postError

        return res.status(201).json({
          success: true,
          message: '실적 등록 성공',
          data: newPerformance[0]
        })

      default:
        return res.status(405).json({
          success: false,
          message: 'Method not allowed'
        })
    }
  } catch (error) {
    console.error('Performance API error:', error)
    return res.status(500).json({
      success: false,
      message: '서버 오류가 발생했습니다.',
      error: error.message
    })
  }
} 