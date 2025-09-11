import fs from 'fs'
import path from 'path'
import { fileURLToPath } from 'url'

const __filename = fileURLToPath(import.meta.url)
const __dirname = path.dirname(__filename)

// 수정할 IP 차단 로직
const newIPLogic = `  // 환경 변수에서 허용된 IP 목록 로드
  const envIPs = process.env.ALLOWED_IPS
  if (!envIPs) {
    console.log('❌ ALLOWED_IPS 환경 변수가 설정되지 않았습니다')
    return { 
      allowed: false, 
      error: {
        success: false,
        message: 'IP 접근 제한 설정이 올바르지 않습니다.',
        error: 'IP_CONFIG_ERROR',
        timestamp: new Date().toISOString()
      }
    }
  }

  const allowedIPs = envIPs.split(',').map(ip => ip.trim()).filter(ip => ip.length > 0)`

// API 파일 목록
const apiFiles = [
  'api/products.js',
  'api/clients.js',
  'api/pharmacies.js',
  'api/notices.js',
  'api/wholesale-sales.js',
  'api/direct-sales.js',
  'api/performance-records.js',
  'api/performance-records-absorption.js',
  'api/performance-evidence-files.js',
  'api/settlement-months.js',
  'api/settlement-share.js',
  'api/hospital-company-mappings.js',
  'api/hospital-pharmacy-mappings.js',
  'api/client-company-assignments.js',
  'api/client-pharmacy-assignments.js',
  'api/product-company-not-assignments.js',
  'api/verify-token.mjs',
  'api/auth.mjs',
  'api/swagger-spec.mjs',
  'api/swagger-ui.mjs'
]

console.log('🔧 모든 API 파일의 IP 차단 로직을 환경 변수 기반으로 수정합니다...')

let successCount = 0
let errorCount = 0

apiFiles.forEach(filePath => {
  try {
    const fullPath = path.join(__dirname, filePath)
    
    if (!fs.existsSync(fullPath)) {
      console.log(`❌ ${filePath} - 파일을 찾을 수 없습니다`)
      errorCount++
      return
    }

    let content = fs.readFileSync(fullPath, 'utf8')
    
    // 하드코딩된 IP 리스트를 찾아서 교체
    const hardcodedIPPattern = /\/\/ 허용된 IP 목록[\s\S]*?const allowedIPs = \[[\s\S]*?\][\s\S]*?\/\/ 환경 변수에서 IP 목록 로드[\s\S]*?if \(envIPs\) \{[\s\S]*?allowedIPs\.push\(\.\.\.envIPs\.split\(','\)\.map\(ip => ip\.trim\(\)\)\)[\s\S]*?\}/
    
    if (hardcodedIPPattern.test(content)) {
      content = content.replace(hardcodedIPPattern, newIPLogic)
      fs.writeFileSync(fullPath, content, 'utf8')
      console.log(`✅ ${filePath} - IP 차단 로직이 환경 변수 기반으로 수정되었습니다`)
      successCount++
    } else {
      console.log(`⏭️ ${filePath} - 수정할 하드코딩된 IP 리스트가 없습니다`)
    }

  } catch (error) {
    console.log(`❌ ${filePath} - 오류: ${error.message}`)
    errorCount++
  }
})

console.log(`\n📊 결과: 성공 ${successCount}개, 실패 ${errorCount}개`)
console.log('🎉 IP 차단 로직 수정이 완료되었습니다!')
