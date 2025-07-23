// Vercel Serverless Function: /api/create-user.js

import { createClient } from '@supabase/supabase-js';

const supabase = createClient(
  process.env.NEXT_PUBLIC_SUPABASE_URL,
  process.env.SUPABASE_SERVICE_ROLE_KEY
);

export default async function handler(req, res) {
  if (req.method !== 'POST') {
    return res.status(405).json({ error: 'Method not allowed' });
  }

  const { email, password, company_name } = req.body;

  if (!email || !password) {
    return res.status(400).json({ error: 'Email and password are required' });
  }

  try {
    // Supabase Auth에 사용자 생성 (admin 권한)
    const { data, error } = await supabase.auth.admin.createUser({
      email,
      password,
      email_confirm: true,
      user_metadata: { company_name }
    });

    if (error) {
      return res.status(400).json({ error: error.message });
    }

    // 생성된 사용자 정보 반환
    return res.status(200).json({ user: data.user });
  } catch (err) {
    return res.status(500).json({ error: err.message });
  }
} 