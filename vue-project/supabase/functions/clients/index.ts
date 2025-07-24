import { serve } from "https://deno.land/std@0.168.0/http/server.ts"
import { createClient } from 'https://esm.sh/@supabase/supabase-js@2'

const corsHeaders = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Headers': 'authorization, x-client-info, apikey, content-type',
}

serve(async (req) => {
  // Handle CORS preflight requests
  if (req.method === 'OPTIONS') {
    return new Response('ok', { headers: corsHeaders })
  }

  try {
    // Create a Supabase client with the Auth context of the function
    const supabaseClient = createClient(
      Deno.env.get('SUPABASE_URL') ?? '',
      Deno.env.get('SUPABASE_ANON_KEY') ?? '',
      { global: { headers: { Authorization: req.headers.get('Authorization')! } } }
    )

    // Only allow GET requests
    if (req.method !== 'GET') {
      return new Response(
        JSON.stringify({
          success: false,
          error: 'method_not_allowed',
          message: 'GET 메서드만 허용됩니다'
        }),
        { 
          status: 405, 
          headers: { ...corsHeaders, 'Content-Type': 'application/json' } 
        }
      )
    }

    // JWT 토큰 검증 (간단한 테스트)
    const authHeader = req.headers.get('authorization')
    if (!authHeader || !authHeader.startsWith('Bearer ')) {
      return new Response(
        JSON.stringify({
          success: false,
          error: 'access_token_required',
          message: '액세스 토큰이 필요합니다'
        }),
        { 
          status: 401, 
          headers: { ...corsHeaders, 'Content-Type': 'application/json' } 
        }
      )
    }

    // Supabase에서 고객 데이터 조회
    const { data: clients, error } = await supabaseClient
      .from('clients')
      .select('*')
      .order('id')
      .limit(50)

    if (error) {
      throw error
    }

    return new Response(
      JSON.stringify({
        success: true,
        data: clients,
        total_count: clients.length,
        user: {
          id: 'test-user-id',
          email: 'admin@shinil.com',
          role: 'admin',
          name: '관리자'
        },
        timestamp: new Date().toISOString()
      }),
      { 
        status: 200, 
        headers: { ...corsHeaders, 'Content-Type': 'application/json' } 
      }
    )

  } catch (error) {
    return new Response(
      JSON.stringify({
        success: false,
        error: 'database_error',
        message: error.message
      }),
      { 
        status: 500, 
        headers: { ...corsHeaders, 'Content-Type': 'application/json' } 
      }
    )
  }
}) 