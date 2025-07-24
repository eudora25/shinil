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

    // Only allow POST requests
    if (req.method !== 'POST') {
      return new Response(
        JSON.stringify({
          success: false,
          error: 'method_not_allowed',
          message: 'POST 메서드만 허용됩니다'
        }),
        { 
          status: 405, 
          headers: { ...corsHeaders, 'Content-Type': 'application/json' } 
        }
      )
    }

    const { email, password } = await req.json()

    if (!email || !password) {
      return new Response(
        JSON.stringify({
          success: false,
          error: 'missing_credentials',
          message: '이메일과 비밀번호를 입력해주세요'
        }),
        { 
          status: 400, 
          headers: { ...corsHeaders, 'Content-Type': 'application/json' } 
        }
      )
    }

    // 간단한 테스트 로그인 (실제로는 Supabase Auth 사용)
    if (email === 'admin@shinil.com' && password === 'admin123') {
      // JWT 토큰 생성 (실제로는 Supabase Auth 사용)
      const token = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6InRlc3QtdXNlci1pZCIsImVtYWlsIjoiYWRtaW5Ac2hpbmlsLmNvbSIsInJvbGUiOiJhZG1pbiIsIm5hbWUiOiLqtIDrpqzsnpAiLCJpYXQiOjE3NTMzMjIzODgsImV4cCI6MTc1MzQwODc4OH0.QH929zKvAauiT5NXgkcjvRv1NHsadWvlxrtDkJBubpg'

      return new Response(
        JSON.stringify({
          success: true,
          data: {
            token,
            user: {
              id: 'test-user-id',
              email: email,
              role: 'admin',
              name: '관리자'
            }
          },
          message: '로그인 성공'
        }),
        { 
          status: 200, 
          headers: { ...corsHeaders, 'Content-Type': 'application/json' } 
        }
      )
    } else {
      return new Response(
        JSON.stringify({
          success: false,
          error: 'invalid_credentials',
          message: '이메일 또는 비밀번호가 올바르지 않습니다'
        }),
        { 
          status: 401, 
          headers: { ...corsHeaders, 'Content-Type': 'application/json' } 
        }
      )
    }

  } catch (error) {
    return new Response(
      JSON.stringify({
        success: false,
        error: 'server_error',
        message: '서버 오류가 발생했습니다: ' + error.message
      }),
      { 
        status: 500, 
        headers: { ...corsHeaders, 'Content-Type': 'application/json' } 
      }
    )
  }
}) 