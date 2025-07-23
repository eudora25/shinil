import { serve } from "https://deno.land/std@0.168.0/http/server.ts"
import { createClient } from 'https://esm.sh/@supabase/supabase-js@2'

const corsHeaders = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Headers': 'authorization, x-client-info, apikey, content-type',
}

serve(async (req) => {
  // Handle CORS preflight requests
  if (req.method === 'OPTIONS') {
    return new Response(null, {
      status: 200,
      headers: corsHeaders,
    })
  }

  try {
    // 요청 데이터 파싱
    const { email, newPassword } = await req.json()
    
    if (!email || !newPassword) {
      throw new Error('이메일과 새 비밀번호가 필요합니다.')
    }

    // Supabase Admin 클라이언트 생성 (Service Role Key 사용)
    const supabaseAdmin = createClient(
      Deno.env.get('SUPABASE_URL') ?? '',
      Deno.env.get('SUPABASE_SERVICE_ROLE_KEY') ?? ''
    )
    
    // 사용자 비밀번호 업데이트
    const { error } = await supabaseAdmin.auth.admin.updateUserByEmail(
      email,
      { password: newPassword }
    )
    
    if (error) {
      console.error('비밀번호 초기화 오류:', error)
      throw error
    }
    
    console.log(`비밀번호 초기화 성공: ${email}`)
    
    return new Response(
      JSON.stringify({ 
        success: true, 
        message: '비밀번호가 성공적으로 초기화되었습니다.' 
      }), 
      {
        headers: { 
          ...corsHeaders,
          'Content-Type': 'application/json' 
        }
      }
    )
  } catch (error) {
    console.error('비밀번호 초기화 실패:', error)
    
    return new Response(
      JSON.stringify({ 
        error: error.message || '비밀번호 초기화에 실패했습니다.' 
      }), 
      {
        status: 400,
        headers: { 
          ...corsHeaders,
          'Content-Type': 'application/json' 
        }
      }
    )
  }
}) 