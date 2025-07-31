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
        // 병원-회원 매핑 목록 조회
        const { data: mappings, error: getError } = await supabase
          .from('hospital_company_mappings')
          .select(`
            *,
            hospitals (hospital_name, business_number),
            companies (company_name, business_number)
          `)
          .order('created_at', { ascending: false })

        if (getError) throw getError

        return res.status(200).json({
          success: true,
          message: '병원-회원 매핑 목록 조회 성공',
          data: mappings
        })

      case 'POST':
        // 새 병원-회원 매핑 등록
        const { hospital_id, company_id, commission_rate } = req.body

        if (!hospital_id || !company_id) {
          return res.status(400).json({
            success: false,
            message: '병원 ID와 회원 ID는 필수입니다.'
          })
        }

        const { data: newMapping, error: postError } = await supabase
          .from('hospital_company_mappings')
          .insert([{
            hospital_id,
            company_id,
            commission_rate: commission_rate ? parseFloat(commission_rate) : 0,
            is_active: true
          }])
          .select()

        if (postError) throw postError

        return res.status(201).json({
          success: true,
          message: '병원-회원 매핑 등록 성공',
          data: newMapping[0]
        })

      default:
        return res.status(405).json({
          success: false,
          message: 'Method not allowed'
        })
    }
  } catch (error) {
    console.error('Hospital mappings API error:', error)
    return res.status(500).json({
      success: false,
      message: '서버 오류가 발생했습니다.',
      error: error.message
    })
  }
} 