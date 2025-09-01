import { serve } from "https://deno.land/std@0.168.0/http/server.ts"

serve(async (req) => {
  // CORS 헤더 설정
  const headers = {
    'Access-Control-Allow-Origin': '*',
    'Access-Control-Allow-Headers': 'authorization, x-client-info, apikey, content-type',
    'Content-Type': 'application/json'
  }

  // OPTIONS 요청 처리 (CORS preflight)
  if (req.method === 'OPTIONS') {
    return new Response('ok', { headers })
  }

  try {
    // Health check 응답
    const response = {
      test: "001",
      status: "OK",
      timestamp: new Date().toISOString(),
      version: "1.0.0",
      environment: "production"
    }

    return new Response(JSON.stringify(response), {
      headers,
      status: 200
    })
  } catch (error) {
    return new Response(JSON.stringify({ error: error.message }), {
      headers,
      status: 500
    })
  }
}) 