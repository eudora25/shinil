import { createClient } from '@supabase/supabase-js'

// 환경 변수에서 Supabase 설정 가져오기
const supabaseUrl = import.meta.env.VITE_SUPABASE_URL || 'https://mctzuqctekhhdfwimxek.supabase.co'
const supabaseAnonKey = import.meta.env.VITE_SUPABASE_ANON_KEY || 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im1jdHp1cWN0ZWtoaGRmd2lteGVrIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTMzMzUyNTUsImV4cCI6MjA2ODkxMTI1NX0.zLH2UFBUG7Zn1ow80Fg69Se8OLN7oRPRrmzFvu9_7gY'

console.log('Supabase URL:', supabaseUrl);
console.log('Supabase Anon Key:', supabaseAnonKey ? '설정됨' : '설정되지 않음');

export const supabase = createClient(supabaseUrl, supabaseAnonKey)