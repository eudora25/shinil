import { createClient } from '@supabase/supabase-js'

// .env.production 파일에서 환경 변수 로드
const supabaseUrl = import.meta.env.VITE_SUPABASE_URL
const supabaseAnonKey = import.meta.env.VITE_SUPABASE_ANON_KEY

console.log('Supabase Env URL:', supabaseUrl); // URL 값 확인
console.log('Supabase Env Anon Key:', supabaseAnonKey); // Anon Key 값 확인

export const supabase = createClient(supabaseUrl, supabaseAnonKey)