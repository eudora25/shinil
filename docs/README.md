# 📚 신일제약 PMS 프로젝트 문서

이 폴더는 신일제약 실적관리프로그램(PMS) 프로젝트의 모든 문서를 포함합니다.

## 📋 **문서 목록**

### **1. [프로젝트 요약](PROJECT_SUMMARY.md)**
- 프로젝트 전체 개요 및 기술 스택
- 주요 기능 및 성능 지표
- 개발 워크플로우 및 배포 환경
- **추천**: 프로젝트를 처음 접하는 분들이 먼저 읽어보세요

### **2. [API 보안 구현 가이드](API_SECURITY_IMPLEMENTATION.md)**
- JWT 토큰 기반 인증 시스템 상세 설명
- API 엔드포인트 보안 구현 방법
- 테스트 방법 및 문제 해결
- **추천**: API 보안 관련 작업을 하시는 분들이 참조하세요

### **3. [Docker 배포 가이드](DOCKER_DEPLOYMENT_GUIDE.md)**
- Docker 컨테이너 환경 구축 방법
- 로컬 및 프로덕션 배포 가이드
- 성능 최적화 및 문제 해결
- **추천**: Docker 환경에서 배포하시는 분들이 참조하세요

### **4. [Vercel 배포 가이드](../VERCEL_DEPLOYMENT_GUIDE.md)**
- Vercel 서버리스 환경 배포 방법
- 환경변수 설정 및 API 함수 구현
- 자동 배포 및 모니터링
- **추천**: Vercel을 사용한 배포를 하시는 분들이 참조하세요

## 🎯 **문서 사용 가이드**

### **개발자별 추천 문서**

#### **신규 개발자**
1. [프로젝트 요약](PROJECT_SUMMARY.md) - 프로젝트 전체 이해
2. [API 보안 구현 가이드](API_SECURITY_IMPLEMENTATION.md) - 보안 시스템 이해
3. [Docker 배포 가이드](DOCKER_DEPLOYMENT_GUIDE.md) - 로컬 개발 환경 구축

#### **프론트엔드 개발자**
1. [프로젝트 요약](PROJECT_SUMMARY.md) - 전체 구조 파악
2. [API 보안 구현 가이드](API_SECURITY_IMPLEMENTATION.md) - API 연동 방법
3. [Vercel 배포 가이드](../VERCEL_DEPLOYMENT_GUIDE.md) - 배포 프로세스

#### **백엔드 개발자**
1. [API 보안 구현 가이드](API_SECURITY_IMPLEMENTATION.md) - 보안 시스템 구현
2. [Docker 배포 가이드](DOCKER_DEPLOYMENT_GUIDE.md) - 서버 환경 구축
3. [프로젝트 요약](PROJECT_SUMMARY.md) - 전체 아키텍처 이해

#### **DevOps 엔지니어**
1. [Docker 배포 가이드](DOCKER_DEPLOYMENT_GUIDE.md) - 컨테이너 환경 관리
2. [Vercel 배포 가이드](../VERCEL_DEPLOYMENT_GUIDE.md) - 클라우드 배포
3. [프로젝트 요약](PROJECT_SUMMARY.md) - 전체 인프라 구조

## 📊 **문서 버전 정보**

| 문서명 | 버전 | 최종 업데이트 | 상태 |
|--------|------|---------------|------|
| 프로젝트 요약 | 1.0.0 | 2024-12-22 | ✅ 완료 |
| API 보안 구현 가이드 | 1.0.0 | 2024-12-22 | ✅ 완료 |
| Docker 배포 가이드 | 1.0.0 | 2024-12-22 | ✅ 완료 |
| Vercel 배포 가이드 | 1.0.0 | 2024-12-22 | ✅ 완료 |

## 🔄 **문서 업데이트 정책**

### **업데이트 주기**
- **주요 기능 추가 시**: 즉시 업데이트
- **버그 수정 시**: 관련 문서 업데이트
- **정기 업데이트**: 월 1회 전체 검토

### **버전 관리**
- **메이저 버전**: 큰 기능 변경 시 (1.0.0 → 2.0.0)
- **마이너 버전**: 기능 추가 시 (1.0.0 → 1.1.0)
- **패치 버전**: 버그 수정 시 (1.0.0 → 1.0.1)

## 🛠️ **문서 작성 가이드**

### **문서 작성 원칙**
1. **명확성**: 이해하기 쉽게 작성
2. **완성성**: 필요한 모든 정보 포함
3. **실용성**: 실제 사용 가능한 예제 제공
4. **일관성**: 통일된 형식과 스타일 사용

### **문서 구조**
```markdown
# 제목

## 개요
- 문서의 목적과 범위

## 주요 내용
- 핵심 내용 설명

## 예제
- 실제 사용 예제

## 문제 해결
- 자주 발생하는 문제와 해결 방법

## 참고 자료
- 관련 링크 및 자료
```

## 📞 **문서 관련 문의**

### **문서 개선 제안**
- GitHub Issues를 통해 제안해 주세요
- Pull Request를 통한 직접 수정도 환영합니다

### **문서 오류 신고**
- 내용 오류나 불일치 발견 시 즉시 신고해 주세요
- 빠른 수정을 위해 구체적인 내용을 포함해 주세요

### **추가 문서 요청**
- 필요한 문서가 있다면 요청해 주세요
- 우선순위에 따라 작성 일정을 조정하겠습니다

## 📚 **외부 참고 자료**

### **기술 문서**
- [Vue.js 공식 문서](https://vuejs.org/guide/)
- [Express.js 가이드](https://expressjs.com/)
- [Docker 공식 문서](https://docs.docker.com/)
- [Vercel 문서](https://vercel.com/docs)

### **보안 관련**
- [JWT 공식 문서](https://jwt.io/)
- [OWASP 보안 가이드](https://owasp.org/)
- [CORS 가이드](https://developer.mozilla.org/en-US/docs/Web/HTTP/CORS)

### **데이터베이스**
- [PostgreSQL 문서](https://www.postgresql.org/docs/)
- [Supabase 문서](https://supabase.com/docs)

---

**📖 이 문서들을 참고하여 신일제약 PMS 프로젝트를 성공적으로 개발하고 배포하시기 바랍니다!**

문서에 대한 피드백이나 개선 제안이 있으시면 언제든지 연락해 주세요. 