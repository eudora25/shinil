import { serve } from 'https://deno.land/std@0.168.0/http/server.ts'
import { createClient } from 'https://esm.sh/@supabase/supabase-js@2'

interface PerformanceFilter {
  settlement_month_id?: number
  company_id?: string
  client_id?: number
  product_id?: string
  user_edit_status?: string
  record_type?: string
  date_from?: string
  date_to?: string
  limit?: number
  offset?: number
}

serve(async (req) => {
  // CORS 헤더 설정
  const corsHeaders = {
    'Access-Control-Allow-Origin': '*',
    'Access-Control-Allow-Headers': 'authorization, x-client-info, apikey, content-type',
    'Access-Control-Allow-Methods': 'GET, POST, OPTIONS'
  }

  // OPTIONS 요청 처리 (CORS preflight)
  if (req.method === 'OPTIONS') {
    return new Response('ok', { headers: corsHeaders })
  }

  try {
    const supabase = createClient(
      Deno.env.get('SUPABASE_URL')!,
      Deno.env.get('SUPABASE_SERVICE_ROLE_KEY')!
    )

    // 요청 본문에서 필터 파라미터 추출
    const filter: PerformanceFilter = await req.json()
    
    // 기본 쿼리 시작 (review_details_view 사용)
    let query = supabase
      .from('review_details_view')
      .select(`
        *,
        companies!inner(company_name, company_type),
        clients!inner(name, hospital_number),
        products!inner(product_name, insurance_code, price),
        settlement_months!inner(settlement_month)
      `)

    // 필터 조건 적용
    if (filter.settlement_month_id) {
      query = query.eq('settlement_month_id', filter.settlement_month_id)
    }

    if (filter.company_id) {
      query = query.eq('company_id', filter.company_id)
    }

    if (filter.client_id) {
      query = query.eq('client_id', filter.client_id)
    }

    if (filter.product_id) {
      query = query.eq('product_id', filter.product_id)
    }

    if (filter.user_edit_status) {
      query = query.eq('user_edit_status', filter.user_edit_status)
    }

    if (filter.record_type) {
      query = query.eq('record_type', filter.record_type)
    }

    if (filter.date_from) {
      query = query.gte('created_at', filter.date_from)
    }

    if (filter.date_to) {
      query = query.lte('created_at', filter.date_to)
    }

    // 정렬 (최신순)
    query = query.order('created_at', { ascending: false })

    // 페이지네이션
    if (filter.limit) {
      query = query.limit(filter.limit)
    }

    if (filter.offset) {
      query = query.range(filter.offset, (filter.offset + (filter.limit || 50)) - 1)
    }

    // 쿼리 실행
    const { data, error, count } = await query

    if (error) {
      return new Response(
        JSON.stringify({ 
          error: 'query_error', 
          message: error.message,
          details: error.details 
        }), 
        { 
          status: 400, 
          headers: { ...corsHeaders, 'Content-Type': 'application/json' } 
        }
      )
    }

    // 응답 데이터 구성
    const response = {
      success: true,
      data: data || [],
      total_count: count || 0,
      filter_applied: filter,
      timestamp: new Date().toISOString()
    }

    return new Response(
      JSON.stringify(response), 
      { 
        status: 200, 
        headers: { ...corsHeaders, 'Content-Type': 'application/json' } 
      }
    )

  } catch (error) {
    return new Response(
      JSON.stringify({ 
        error: 'server_error', 
        message: error.message 
      }), 
      { 
        status: 500, 
        headers: { ...corsHeaders, 'Content-Type': 'application/json' } 
      }
    )
  }
}) 