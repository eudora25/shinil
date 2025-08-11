// IP 접근 제어 설정
const IP_ACCESS_CONFIG = {
  // 허용된 IP 주소 목록
  allowedIPs: [
    '127.0.0.1',        // localhost
    '::1',              // localhost IPv6
    '192.168.1.100',    // 예시: 허용할 IP 주소
    '203.241.xxx.xxx',  // 예시: 허용할 IP 주소 (실제 IP로 변경 필요)
    '1.214.163.196'     // 현재 사용자 IP
  ],

  // 환경 변수에서 IP 목록 로드
  loadFromEnv() {
    const envIPs = process.env.ALLOWED_IPS
    if (envIPs) {
      this.allowedIPs = envIPs.split(',').map(ip => ip.trim())
    }
    return this.allowedIPs
  },

  // IP 주소를 long으로 변환
  ipToLong(ip) {
    return ip.split('.').reduce((acc, octet) => (acc << 8) + parseInt(octet), 0) >>> 0
  },

  // IP 접근 권한 확인
  isIPAllowed(clientIP) {
    return this.allowedIPs.some(allowedIP => {
      // 정확한 IP 매칭
      if (allowedIP === clientIP) return true
      
      // CIDR 표기법 지원 (예: 192.168.1.0/24)
      if (allowedIP.includes('/')) {
        const [network, bits] = allowedIP.split('/')
        const mask = ~((1 << (32 - parseInt(bits))) - 1)
        const networkLong = this.ipToLong(network) & mask
        const ipLong = this.ipToLong(clientIP) & mask
        return networkLong === ipLong
      }
      
      return false
    })
  },

  // IP 접근 미들웨어 생성
  createMiddleware() {
    return (req, res, next) => {
      const clientIP = req.ip || req.connection.remoteAddress || req.socket.remoteAddress || req.connection.socket?.remoteAddress
      
      // X-Forwarded-For 헤더에서 실제 IP 확인 (프록시 환경)
      const forwardedIP = req.headers['x-forwarded-for']?.split(',')[0]?.trim()
      const realIP = forwardedIP || clientIP
      
      console.log(`🔒 IP 접근 시도: ${realIP}`)
      console.log(`🔒 허용된 IP 목록:`, this.allowedIPs)
      
      if (!this.isIPAllowed(realIP)) {
        console.log(`❌ 접근 거부: ${realIP}`)
        return res.status(403).json({
          success: false,
          message: '접근이 거부되었습니다. 허용된 IP에서만 접근 가능합니다.',
          error: 'IP_ACCESS_DENIED',
          clientIP: realIP,
          allowedIPs: this.allowedIPs
        })
      }
      
      console.log(`✅ 접근 허용: ${realIP}`)
      next()
    }
  }
}

export default IP_ACCESS_CONFIG
