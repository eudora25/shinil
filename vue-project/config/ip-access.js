// IP 접근 제어 설정
const IP_ACCESS_CONFIG = {
  // 허용된 IP 주소 목록
  allowedIPs: [
    '127.0.0.1',        // localhost
    '::1',              // localhost IPv6
    '192.168.1.119',    // 예시: 허용할 IP 주소
    '203.241.xxx.xxx',  // 예시: 허용할 IP 주소 (실제 IP로 변경 필요)
    '1.214.163.196',    // 현재 사용자 IP
    '192.168.65.1',     // Docker/개발 환경 IP
    '::ffff:192.168.65.1',  // IPv4-mapped IPv6 형식
    '112.187.169.69',   // 추가 허용 IP
    '58.229.119.165',   // 추가 허용 IP
    '172.19.0.1',       // Docker 컨테이너 네트워크 IP
    '::ffff:172.19.0.1', // Docker 컨테이너 네트워크 IP (IPv6 형식)
    '172.64.149.246',   // 현재 클라이언트 IP
    '::ffff:172.64.149.246' // 현재 클라이언트 IP (IPv6 형식)
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
      
      // IPv4-mapped IPv6 주소 처리 (::ffff:192.168.65.1 -> 192.168.65.1)
      if (clientIP.startsWith('::ffff:')) {
        const ipv4Part = clientIP.substring(7) // ::ffff: 제거
        if (allowedIP === ipv4Part) return true
      }
      
      // IPv4 주소를 IPv4-mapped IPv6로 변환해서 매칭
      if (allowedIP.includes('.') && !allowedIP.includes(':')) {
        const mappedIPv6 = `::ffff:${allowedIP}`
        if (clientIP === mappedIPv6) return true
      }
      
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
          error: 'IP_ACCESS_DENIED'
        })
      }
      
      console.log(`✅ 접근 허용: ${realIP}`)
      next()
    }
  }
}

export default IP_ACCESS_CONFIG
