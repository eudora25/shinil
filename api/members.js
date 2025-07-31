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
        // 회원 목록 조회
        const { data: members, error: getError } = await supabase
          .from('companies')
          .select('*')
          .order('created_at', { ascending: false })

        if (getError) throw getError

        return res.status(200).json({
          success: true,
          message: '회원 목록 조회 성공',
          data: members
        })

      case 'POST':
        // 새 회원 등록
        const { company_name, business_number, representative, address, phone, email } = req.body

        if (!company_name || !business_number || !representative) {
          return res.status(400).json({
            success: false,
            message: '회사명, 사업자등록번호, 대표자는 필수입니다.'
          })
        }

        const { data: newMember, error: postError } = await supabase
          .from('companies')
          .insert([{
            company_name,
            business_number,
            representative,
            address,
            phone,
            email,
            approval_status: 'pending'
          }])
          .select()

        if (postError) throw postError

        return res.status(201).json({
          success: true,
          message: '회원 등록 성공',
          data: newMember[0]
        })

      default:
        return res.status(405).json({
          success: false,
          message: 'Method not allowed'
        })
    }
  } catch (error) {
    console.error('Members API error:', error)
    return res.status(500).json({
      success: false,
      message: '서버 오류가 발생했습니다.',
      error: error.message
    })
  }
} 