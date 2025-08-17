import { createClient } from '@supabase/supabase-js'

function getEnvironmentVariables() {
  const supabaseUrl = process.env.VITE_SUPABASE_URL || process.env.SUPABASE_URL
  const supabaseAnonKey = process.env.VITE_SUPABASE_ANON_KEY || process.env.SUPABASE_ANON_KEY
  return { supabaseUrl, supabaseAnonKey }
}

function createSupabaseClient() {
  const { supabaseUrl, supabaseAnonKey } = getEnvironmentVariables()
  if (!supabaseUrl || !supabaseAnonKey) {
    throw new Error('Supabase configuration missing')
  }
  try {
    return createClient(supabaseUrl, supabaseAnonKey)
  } catch (error) {
    console.error('Failed to create Supabase client:', error)
    throw error
  }
}

export default async function handler(req, res) {
  res.setHeader('Access-Control-Allow-Origin', '*')
  res.setHeader('Access-Control-Allow-Methods', 'GET, POST, PUT, DELETE, OPTIONS')
  res.setHeader('Access-Control-Allow-Headers', 'Content-Type, Authorization')
  res.setHeader('Content-Type', 'application/json')

  if (req.method === 'OPTIONS') {
    res.status(200).end()
    return
  }

  try {
    let supabase
    try {
      supabase = createSupabaseClient()
    } catch (configError) {
      console.error('Supabase configuration error:', configError)
      return res.status(500).json({
        success: false,
        message: 'Server configuration error',
        error: 'Supabase client initialization failed',
        details: configError.message
      })
    }

    // GET: 병원-약국 매핑 목록 조회
    if (req.method === 'GET') {
      const page = parseInt(req.query.page) || 1
      const limit = parseInt(req.query.limit) || 100
      const hospitalId = req.query.hospital_id
      const pharmacyId = req.query.pharmacy_id
      const status = req.query.status || 'active'

      const limitNum = Math.min(Math.max(1, limit), 1000)
      const pageNum = Math.max(1, page)
      const offset = (pageNum - 1) * limitNum

      let query = supabase
        .from('hospital_pharmacy_mappings')
        .select('*', { count: 'exact' })
        .order('created_at', { ascending: false })

      // 필터링
      if (hospitalId) {
        query = query.eq('hospital_id', hospitalId)
      }
      if (pharmacyId) {
        query = query.eq('pharmacy_id', pharmacyId)
      }
      if (status && status !== 'all') {
        query = query.eq('status', status)
      }

      // 페이지네이션
      query = query.range(offset, offset + limitNum - 1)

      const { data: mappings, error: getError, count } = await query

      if (getError) throw getError

      const totalPages = Math.ceil(count / limitNum)
      const hasNextPage = pageNum < totalPages
      const hasPrevPage = pageNum > 1

      return res.status(200).json({
        success: true,
        message: '병원-약국 매핑 목록 조회 성공',
        data: mappings,
        pagination: {
          currentPage: pageNum,
          limit: limitNum,
          totalCount: count,
          totalPages: totalPages,
          hasNextPage: hasNextPage,
          hasPrevPage: hasPrevPage
        }
      })
    }

    // POST: 새로운 병원-약국 매핑 생성
    if (req.method === 'POST') {
      const { hospital_id, pharmacy_id, status = 'active', remarks } = req.body

      if (!hospital_id || !pharmacy_id) {
        return res.status(400).json({
          success: false,
          message: '병원 ID와 약국 ID는 필수입니다.'
        })
      }

      // 중복 매핑 확인
      const { data: existingMapping, error: checkError } = await supabase
        .from('hospital_pharmacy_mappings')
        .select('*')
        .eq('hospital_id', hospital_id)
        .eq('pharmacy_id', pharmacy_id)
        .single()

      if (checkError && checkError.code !== 'PGRST116') {
        throw checkError
      }

      if (existingMapping) {
        return res.status(409).json({
          success: false,
          message: '이미 존재하는 병원-약국 매핑입니다.'
        })
      }

      const { data: newMapping, error: createError } = await supabase
        .from('hospital_pharmacy_mappings')
        .insert({
          hospital_id,
          pharmacy_id,
          status,
          remarks
        })
        .select()
        .single()

      if (createError) throw createError

      return res.status(201).json({
        success: true,
        message: '병원-약국 매핑 생성 성공',
        data: newMapping
      })
    }

    // PUT: 병원-약국 매핑 수정
    if (req.method === 'PUT') {
      const { id, status, remarks } = req.body

      if (!id) {
        return res.status(400).json({
          success: false,
          message: '매핑 ID는 필수입니다.'
        })
      }

      const updateData = {}
      if (status !== undefined) updateData.status = status
      if (remarks !== undefined) updateData.remarks = remarks

      const { data: updatedMapping, error: updateError } = await supabase
        .from('hospital_pharmacy_mappings')
        .update(updateData)
        .eq('id', id)
        .select()
        .single()

      if (updateError) throw updateError

      if (!updatedMapping) {
        return res.status(404).json({
          success: false,
          message: '해당 매핑을 찾을 수 없습니다.'
        })
      }

      return res.status(200).json({
        success: true,
        message: '병원-약국 매핑 수정 성공',
        data: updatedMapping
      })
    }

    // DELETE: 병원-약국 매핑 삭제
    if (req.method === 'DELETE') {
      const { id } = req.query

      if (!id) {
        return res.status(400).json({
          success: false,
          message: '매핑 ID는 필수입니다.'
        })
      }

      const { data: deletedMapping, error: deleteError } = await supabase
        .from('hospital_pharmacy_mappings')
        .delete()
        .eq('id', id)
        .select()
        .single()

      if (deleteError) throw deleteError

      if (!deletedMapping) {
        return res.status(404).json({
          success: false,
          message: '해당 매핑을 찾을 수 없습니다.'
        })
      }

      return res.status(200).json({
        success: true,
        message: '병원-약국 매핑 삭제 성공',
        data: deletedMapping
      })
    }

    return res.status(405).json({
      success: false,
      message: 'Method not allowed. Use GET, POST, PUT, or DELETE.'
    })

  } catch (error) {
    console.error('Hospital-Pharmacy Mappings API error details:', {
      message: error.message,
      stack: error.stack,
      timestamp: new Date().toISOString()
    })

    return res.status(500).json({
      success: false,
      message: '서버 오류가 발생했습니다.',
      error: error.message,
      timestamp: new Date().toISOString()
    })
  }
}
