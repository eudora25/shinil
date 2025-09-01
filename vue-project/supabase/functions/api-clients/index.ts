import { serve } from "https://deno.land/std@0.168.0/http/server.ts"
import { createClient } from 'https://esm.sh/@supabase/supabase-js@2'

const corsHeaders = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Headers': 'authorization, x-client-info, apikey, content-type',
}

serve(async (req) => {
  // CORS preflight 요청 처리
  if (req.method === 'OPTIONS') {
    return new Response('ok', { headers: corsHeaders })
  }

  try {
    // Supabase 클라이언트 생성
    const supabaseClient = createClient(
      Deno.env.get('SUPABASE_URL') ?? '',
      Deno.env.get('SUPABASE_ANON_KEY') ?? '',
      {
        global: {
          headers: { Authorization: req.headers.get('Authorization')! },
        },
      }
    )

    // URL 파라미터 파싱
    const url = new URL(req.url)
    const limit = parseInt(url.searchParams.get('limit') || '100')
    const offset = parseInt(url.searchParams.get('offset') || '0')
    const search = url.searchParams.get('search') || ''
    const companyId = url.searchParams.get('company_id') || ''

    // 쿼리 빌더 생성
    let query = supabaseClient
      .from('clients')
      .select(`
        *,
        companies!clients_assigned_company_id_fkey (
          company_name
        )
      `)
      .order('hospital_name')

    // 검색 필터 적용
    if (search) {
      query = query.ilike('hospital_name', `%${search}%`)
    }

    // 업체 필터 적용
    if (companyId) {
      query = query.eq('assigned_company_id', companyId)
    }

    // 페이지네이션 적용
    query = query.range(offset, offset + limit - 1)

    // 데이터 조회
    const { data, error, count } = await query

    if (error) {
      return new Response(
        JSON.stringify({
          success: false,
          error: error.message,
          message: '병의원 정보를 조회하는 중 오류가 발생했습니다.'
        }),
        {
          status: 500,
          headers: { ...corsHeaders, 'Content-Type': 'application/json' },
        }
      )
    }

    // 데이터 가공
    const processedData = (data || []).map(client => ({
      ...client,
      assigned_company_name: client.companies?.company_name || null
    }))

    // 응답 데이터 구성
    const response = {
      success: true,
      data: processedData,
      total: count || 0,
      limit,
      offset,
      timestamp: new Date().toISOString()
    }

    return new Response(
      JSON.stringify(response),
      {
        status: 200,
        headers: { ...corsHeaders, 'Content-Type': 'application/json' },
      }
    )

  } catch (error) {
    return new Response(
      JSON.stringify({
        success: false,
        error: error.message,
        message: '서버 오류가 발생했습니다.'
      }),
      {
        status: 500,
        headers: { ...corsHeaders, 'Content-Type': 'application/json' },
      }
    )
  }
}) 