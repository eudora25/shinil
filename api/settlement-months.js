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
        // 정산월 목록 조회
        const { data: settlementMonths, error: getError } = await supabase
          .from('settlement_months')
          .select('*')
          .order('settlement_month', { ascending: false })

        if (getError) throw getError

        return res.status(200).json({
          success: true,
          message: '정산월 목록 조회 성공',
          data: settlementMonths
        })

      case 'POST':
        // 새 정산월 등록
        const { 
          settlement_month, 
          registration_start_date, 
          registration_end_date,
          settlement_date,
          status 
        } = req.body

        if (!settlement_month || !registration_start_date || !registration_end_date) {
          return res.status(400).json({
            success: false,
            message: '정산월, 등록 시작일, 등록 종료일은 필수입니다.'
          })
        }

        const { data: newSettlementMonth, error: postError } = await supabase
          .from('settlement_months')
          .insert([{
            settlement_month,
            registration_start_date,
            registration_end_date,
            settlement_date,
            status: status || 'open'
          }])
          .select()

        if (postError) throw postError

        return res.status(201).json({
          success: true,
          message: '정산월 등록 성공',
          data: newSettlementMonth[0]
        })

      default:
        return res.status(405).json({
          success: false,
          message: 'Method not allowed'
        })
    }
  } catch (error) {
    console.error('Settlement months API error:', error)
    return res.status(500).json({
      success: false,
      message: '서버 오류가 발생했습니다.',
      error: error.message
    })
  }
} 