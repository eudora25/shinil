import { serve } from 'https://deno.land/std@0.168.0/http/server.ts'
import { createClient } from 'https://esm.sh/@supabase/supabase-js@2'

serve(async (req) => {
  const { email, password, company_name, business_registration_number, representative_name, business_address, contact_person_name, mobile_phone } = await req.json()

  const supabase = createClient(
    Deno.env.get('SUPABASE_URL')!,
    Deno.env.get('SUPABASE_SERVICE_ROLE_KEY')!
  )

  // 1. Auth 계정 생성
  const { data: authData, error: authError } = await supabase.auth.admin.createUser({
    email,
    password,
    user_metadata: { user_type: 'user', approval_status: 'pending' },
    email_confirm: true
  })
  if (authError) {
    return new Response(JSON.stringify({ error: 'auth', message: authError.message }), { status: 400 })
  }
  const user_id = authData.user?.id
  if (!user_id) {
    return new Response(JSON.stringify({ error: 'auth', message: 'user_id 생성 실패' }), { status: 400 })
  }

  // 2. companies 테이블 insert
  const { error: companyError } = await supabase.from('companies').insert([{
    user_id,
    email,
    company_name,
    business_registration_number,
    representative_name,
    business_address,
    contact_person_name,
    mobile_phone,
    user_type: 'user',
    approval_status: 'pending',
    status: 'active'
  }])
  if (companyError) {
    return new Response(JSON.stringify({ error: 'company', message: companyError.message }), { status: 400 })
  }

  return new Response(JSON.stringify({ success: true }), { status: 200 })
})