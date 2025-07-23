import { createClient } from '@supabase/supabase-js'

console.log('Supabase Env URL:', import.meta.env.VITE_SUPABASE_URL); // URL 값 확인
console.log('Supabase Env Anon Key:', import.meta.env.VITE_SUPABASE_ANON_KEY); // Anon Key 값 확인
console.log('All Env Vars:', import.meta.env); // 전체 환경 변수 객체 확인

const supabaseUrl = import.meta.env.VITE_SUPABASE_URL
const supabaseAnonKey = import.meta.env.VITE_SUPABASE_ANON_KEY

export const supabase = createClient(supabaseUrl, supabaseAnonKey)