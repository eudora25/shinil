<template>
  <div class="manual-container">
    <div class="manual-content">
      <!-- 고정될 헤더 영역 (제목 + 탭) -->
      <div class="manual-header">
        <div class="header-top">
          <h1>{{ isAdminManual ? '신일제약 CSO 실적 관리 시스템 - 관리자 메뉴얼' : '신일제약 CSO 실적 관리 시스템 - 이용자 메뉴얼' }}</h1>
          <!-- PDF 다운로드 버튼 : 일시 감추기 -->
          <!--
          <Button 
            label="PDF 다운로드" 
            icon="pi pi-download" 
            iconPos="right"
            @click="downloadPDF" 
            :loading="isPrinting" 
            text severity="secondary" 
            class="pdf-download-button" 
            aria-label="PDF 다운로드"
          />
          -->
        </div>
        
        <!-- 탭 메뉴 -->
        <div class="manual-tabs">
          <div 
            v-for="(tab, index) in tabs" 
            :key="index"
            class="manual-tab"
            :class="{ active: activeTab === index }"
            @click="activeTab = index"
          >
            {{ tab.label }}
          </div>
        </div>
      </div>
      
      <!-- 탭 내용 -->
      <div v-html="tabs[activeTab]?.content" class="manual-html-content"></div>

      <!-- PDF 렌더링을 위한 숨겨진 컨테이너 -->
      <div v-if="isPrinting" style="position: absolute; left: -9999px; top: -9999px;">
        <div id="pdf-render-container" v-html="fullManualContent" class="manual-html-content" style="width: 1200px; background: white;"></div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { computed, ref, nextTick } from 'vue';
import { useRoute } from 'vue-router';
import Button from 'primevue/button';
import jsPDF from 'jspdf';
import html2canvas from 'html2canvas';

const route = useRoute();
const activeTab = ref(0);
const isPrinting = ref(false);

const isAdminManual = computed(() => route.path === '/admin-manual');

const fullManualContent = computed(() => {
  return tabs.value.map(tab => tab.content).join('');
});

const downloadPDF = async () => {
  isPrinting.value = true;
  await nextTick();

  const renderContainer = document.getElementById('pdf-render-container');
  if (!renderContainer) {
    isPrinting.value = false;
    return;
  }

  const title = isAdminManual.value ? '관리자 메뉴얼' : '이용자 메뉴얼';
  const fileName = `${title}.pdf`;

  const pdf = new jsPDF('p', 'mm', 'a4');
  const margin = { top: 20, right: 15, bottom: 20, left: 15 };
  const pdfWidth = pdf.internal.pageSize.getWidth() - margin.left - margin.right;
  const pageHeight = pdf.internal.pageSize.getHeight() - margin.top - margin.bottom;

  const sections = renderContainer.querySelectorAll('.section');

  try {
    for (let i = 0; i < sections.length; i++) {
      const section = sections[i];
      const canvas = await html2canvas(section, {
        scale: 2,
        useCORS: true,
        backgroundColor: '#ffffff'
      });

      const imgData = canvas.toDataURL('image/png');
      const ratio = canvas.width / pdfWidth;
      const imgHeight = canvas.height / ratio;

      if (imgHeight > pageHeight) {
        let heightLeft = imgHeight;
        let position = 0;

        pdf.addImage(imgData, 'PNG', margin.left, margin.top, pdfWidth, imgHeight);
        heightLeft -= pageHeight;

        while (heightLeft > 0) {
          position -= pageHeight;
          pdf.addPage();
          pdf.addImage(imgData, 'PNG', margin.left, margin.top + position, pdfWidth, imgHeight);
          heightLeft -= pageHeight;
        }
      } else {
        pdf.addImage(imgData, 'PNG', margin.left, margin.top, pdfWidth, imgHeight);
      }

      if (i < sections.length - 1) {
        pdf.addPage();
      }
    }
    pdf.save(fileName);
  } catch (error) {
    console.error('PDF 생성 오류:', error);
  } finally {
    isPrinting.value = false;
  }
};

// 관리자 탭 내용
const adminTabs = [
  {
    label: '1. 공지사항 관리',
    content: `
      <div class="section">
        <h2>1. 공지사항 관리</h2>
        <h3>1.1 공지사항 목록 <span class="path">/admin/notices</span></h3>
        <p><strong>설명:</strong> 공지사항을 조회하고 관리할 수 있습니다.</p>
        
        <img src="/manual-images/admin_1_notice_list.png" alt="공지사항 목록" class="manual-image">
        
        <h4>주요 기능:</h4>
        <ul class="feature-list">
          <li><strong>공지사항 목록 조회</strong> - 등록된 모든 공지사항을 제목, 작성일시, 조회수, 고정여부와 함께 확인할 수 있습니다.</li>
          <li><strong>공지사항 등록</strong> - 새로운 공지사항을 작성하고, 중요도에 따라 상단 고정 여부를 설정할 수 있습니다.</li>
          <li><strong>공지사항 수정</strong> - 기존에 등록된 공지사항의 내용을 수정할 수 있습니다.</li>
          <li><strong>공지사항 삭제</strong> - 더 이상 필요하지 않은 공지사항을 시스템에서 삭제합니다.</li>
          <li><strong>첨부파일 관리</strong> - 공지사항에 관련 파일을 첨부하여 사용자들이 다운로드할 수 있도록 합니다.</li>
        </ul>
      </div>
    `
  },
  {
    label: '2. 업체 관리',
    content: `
      <div class="section">
        <h2>2. 업체 관리</h2>
        <h3>2.1 승인 업체 목록 <span class="path">/admin/companies/approved</span></h3>
        <p><strong>설명:</strong> CSO 업체의 기본 정보를 조회하고 관리할 수 있습니다.</p>
        
        <img src="/manual-images/admin_2_1_company_list.png" alt="승인 업체 목록" class="manual-image">
        
        <h4>주요 기능:</h4>
        <ul class="feature-list">
          <li><strong>업체 목록 조회</strong> - 승인된 CSO 업체들의 기본 정보(업체명, 사업자번호, 대표자명, 담당자, 연락처, 수수료 등급, 상태)를 테이블 형태로 확인할 수 있습니다.</li>
          <li><strong>업체 상세 정보 조회</strong> - 특정 업체를 선택하여 등록된 모든 정보를 상세히 확인할 수 있습니다.</li>
          <li><strong>업체 정보 수정</strong> - 업체의 담당자, 연락처, 주소 등 기본 정보를 수정할 수 있습니다.</li>
          <li><strong>업체 상태 변경</strong> - 업체의 활성/비활성 상태를 변경하여 시스템 이용 권한을 관리할 수 있습니다.</li>
          <li><strong>업체 삭제</strong> - 더 이상 거래하지 않는 업체 정보를 시스템에서 완전히 삭제할 수 있습니다.</li>
        </ul>
        
        <h3>2.2 미승인 업체 목록 <span class="path">/admin/companies/pending</span></h3>
        <p><strong>설명:</strong> 신규 등록된 CSO 업체의 승인/반려 처리를 할 수 있습니다.</p>
        
        <img src="/manual-images/admin_2_2_company_list.png" alt="미승인 업체 목록" class="manual-image">
        
        <h4>주요 기능:</h4>
        <ul class="feature-list">
          <li><strong>미승인 업체 목록 조회</strong> - 신규 가입 신청한 CSO 업체들의 대기 목록을 확인할 수 있습니다.</li>
          <li><strong>업체 정보 검토</strong> - 신청업체의 사업자등록증, 업체 정보, 담당자 정보 등을 상세히 검토할 수 있습니다.</li>
          <li><strong>승인/반려 처리</strong> - 검토 결과에 따라 업체 가입을 승인하거나 반려할 수 있습니다.</li>
          <li><strong>승인 시 수수료 등급 설정</strong> - 승인과 동시에 해당 업체의 수수료 등급(A, B, C 등)을 설정할 수 있습니다.</li>
          <li><strong>처리 결과 이메일 발송</strong> - 승인/반려 결과를 해당 업체 담당자에게 자동으로 이메일로 통지합니다.</li>
        </ul>
      </div>
    `
  },
  {
    label: '3. 제품 관리',
    content: `
      <div class="section">
        <h2>3. 제품 관리</h2>
        <h3>3.1 제품 목록 <span class="path">/admin/products</span></h3>
        <p><strong>설명:</strong> 제품 정보를 조회하고 관리할 수 있습니다.</p>
        
        <img src="/manual-images/admin_3_1_product_list.png" alt="제품 목록" class="manual-image">
        
        <h4>📤 엑셀 등록 (5단계 확인 프로세스):</h4>
        <div class="process-steps">
          <div class="step">
            <strong>1단계: 기존 데이터 존재 확인</strong><br>
            <em>조건:</em> 기존 제품이 있는 경우<br>
            <em>메시지:</em> "기존 데이터가 있습니다. 계속 등록하시겠습니까?"<br>
            <em>확인:</em> 2단계로 진행 / <em>취소:</em> 작업 중단
          </div>
          <div class="step">
            <strong>2단계: 추가 vs 대체 선택</strong><br>
            <em>메시지:</em> "기존 데이터에 추가하시겠습니까? 대체하시겠습니까?"<br>
            <em>추가:</em> 추가 모드 → 3단계 (중복 체크)<br>
            <em>대체:</em> 대체 모드 → 기존 데이터 삭제 후 바로 등록 (중복 체크 건너뜀)
          </div>
          <div class="step">
            <strong>3단계: 중복 체크 (추가 모드에서만)</strong><br>
            <em>기준:</em> 표준코드 + 기준월 중복 확인<br>
            <em>중복 없음:</em> 바로 등록 / <em>중복 있음:</em> 4단계로 진행
          </div>
          <div class="step">
            <strong>4단계: 중복 발견 시 계속 진행 여부</strong><br>
            <em>메시지:</em> "n행: 이미 동일한 표준코드의 제품이 등록되어 있습니다. 계속 등록 작업을 진행하시겠습니까?"<br>
            <em>확인:</em> 5단계로 진행 / <em>취소:</em> 작업 중단
          </div>
          <div class="step">
            <strong>5단계: 중복 해결 방법 선택</strong><br>
            <em>메시지:</em> "이미 동일한 표준코드 제품을 어떻게 처리하시겠습니까?"<br>
            <em>교체:</em> 기존 제품정보 삭제 후 신규 제품 등록<br>
            <em>유지:</em> 중복되지 않는 신규 제품만 등록 (기존 유지)
          </div>
        </div>
      </div>
    `
  },
  {
    label: '4. 병의원 관리',
    content: `
      <div class="section">
        <h2>4. 병의원 관리</h2>
        <h3>4.1 병의원 목록 <span class="path">/admin/clients</span></h3>
        <p><strong>설명:</strong> 병의원(병원) 정보를 조회하고 관리할 수 있습니다.</p>
        
        <img src="/manual-images/admin_4_1_hospital_list.png" alt="병의원 목록" class="manual-image">
        
        <h4>📤 엑셀 등록 (5단계 확인 프로세스):</h4>
        <div class="process-steps">
          <div class="step">
            <strong>1단계: 기존 데이터 존재 확인</strong><br>
            <em>조건:</em> 기존 병의원이 있는 경우<br>
            <em>메시지:</em> "기존 데이터가 있습니다. 계속 등록하시겠습니까?"<br>
            <em>확인:</em> 2단계로 진행 / <em>취소:</em> 작업 중단
          </div>
          <div class="step">
            <strong>2단계: 추가 vs 대체 선택</strong><br>
            <em>메시지:</em> "기존 데이터에 추가하시겠습니까? 대체하시겠습니까?"<br>
            <em>추가:</em> 추가 모드 → 3단계 (중복 체크)<br>
            <em>대체:</em> 대체 모드 → 기존 데이터 삭제 후 바로 등록 (중복 체크 건너뜀)
          </div>
          <div class="step">
            <strong>3단계: 중복 체크 (추가 모드에서만)</strong><br>
            <em>기준:</em> 사업자등록번호 중복 확인<br>
            <em>중복 없음:</em> 바로 등록 / <em>중복 있음:</em> 4단계로 진행
          </div>
          <div class="step">
            <strong>4단계: 중복 발견 시 계속 진행 여부</strong><br>
            <em>메시지:</em> "n행: 이미 동일한 사업자등록번호의 병의원이 등록되어 있습니다. 계속 등록 작업을 진행하시겠습니까?"<br>
            <em>확인:</em> 5단계로 진행 / <em>취소:</em> 작업 중단
          </div>
          <div class="step">
            <strong>5단계: 중복 해결 방법 선택</strong><br>
            <em>메시지:</em> "이미 동일한 사업자등록번호 병의원을 어떻게 처리하시겠습니까?"<br>
            <em>교체:</em> 기존 병의원정보 삭제 후 신규 병의원 등록<br>
            <em>유지:</em> 중복되지 않는 신규 병의원만 등록 (기존 유지)
          </div>
        </div>

        <h3>4.2 담당업체 지정 <span class="path">/admin/clients/assign-companies</span></h3>
        <p><strong>설명:</strong> 특정 병의원에 실적을 등록할 담당 CSO 업체를 지정하고 관리합니다. 이 설정을 통해 업체별로 담당 병의원이 명확하게 구분됩니다.</p>
        <img src="/manual-images/admin_4_2_hospital-company_list.png" alt="담당업체 지정" class="manual-image">
        <h4>주요 기능:</h4>
        <ul class="feature-list">
            <li><strong>병의원별 담당업체 지정</strong> - 병의원을 선택한 후, 해당 병의원을 담당할 CSO 업체를 목록에서 찾아 지정할 수 있습니다.</li>
            <li><strong>다중 업체 지정</strong> - 하나의 병의원에 여러 CSO 업체를 담당으로 지정할 수 있습니다.</li>
            <li><strong>담당업체 조회 및 해제</strong> - 특정 병의원에 현재 지정된 담당업체 목록을 확인하고, 필요 시 지정을 해제할 수 있습니다.</li>
        </ul>

        <h3>4.3 문전약국 지정 <span class="path">/admin/clients/assign-pharmacies</span></h3>
        <p><strong>설명:</strong> 병의원과 연관된 문전약국을 지정하여 관리합니다. 실적 데이터의 정확성을 높이기 위해 병의원-약국 관계를 설정합니다.</p>
        <img src="/manual-images/admin_4_3_hospital-pharmacies_list.png" alt="문전약국 지정" class="manual-image">
        <h4>주요 기능:</h4>
        <ul class="feature-list">
            <li><strong>병의원별 문전약국 지정</strong> - 병의원을 선택한 후, 관련 문전약국을 목록에서 찾아 지정할 수 있습니다.</li>
            <li><strong>다중 약국 지정</strong> - 하나의 병의원에 여러 문전약국을 지정할 수 있습니다.</li>
            <li><strong>지정된 약국 조회 및 해제</strong> - 특정 병의원에 지정된 문전약국 목록을 확인하고, 필요 시 지정을 해제할 수 있습니다.</li>
        </ul>
      </div>
    `
  },
  {
    label: '5. 문전약국 관리',
    content: `
      <div class="section">
        <h2>5. 문전약국 관리</h2>
        <h3>5.1 문전약국 목록 <span class="path">/admin/pharmacies</span></h3>
        <p><strong>설명:</strong> 문전약국 정보를 조회하고 관리할 수 있습니다.</p>
        
        <img src="/manual-images/admin_5_pharmacies_list.png" alt="문전약국 목록" class="manual-image">
        
        <h4>📤 엑셀 등록 (5단계 확인 프로세스):</h4>
        <div class="process-steps">
          <div class="step">
            <strong>1단계: 기존 데이터 존재 확인</strong><br>
            <em>조건:</em> 기존 문전약국이 있는 경우<br>
            <em>메시지:</em> "기존 데이터가 있습니다. 계속 등록하시겠습니까?"<br>
            <em>확인:</em> 2단계로 진행 / <em>취소:</em> 작업 중단
          </div>
          <div class="step">
            <strong>2단계: 추가 vs 대체 선택</strong><br>
            <em>메시지:</em> "기존 데이터에 추가하시겠습니까? 대체하시겠습니까?"<br>
            <em>추가:</em> 추가 모드 → 3단계 (중복 체크)<br>
            <em>대체:</em> 대체 모드 → 기존 데이터 삭제 후 바로 등록 (중복 체크 건너뜀)
          </div>
          <div class="step">
            <strong>3단계: 중복 체크 (추가 모드에서만)</strong><br>
            <em>기준:</em> 사업자등록번호 중복 확인<br>
            <em>중복 없음:</em> 바로 등록 / <em>중복 있음:</em> 4단계로 진행
          </div>
          <div class="step">
            <strong>4단계: 중복 발견 시 계속 진행 여부</strong><br>
            <em>메시지:</em> "n행: 이미 동일한 사업자등록번호의 약국이 등록되어 있습니다. 계속 등록 작업을 진행하시겠습니까?"<br>
            <em>확인:</em> 5단계로 진행 / <em>취소:</em> 작업 중단
          </div>
          <div class="step">
            <strong>5단계: 중복 해결 방법 선택</strong><br>
            <em>메시지:</em> "이미 동일한 사업자등록번호 약국을 어떻게 처리하시겠습니까?"<br>
            <em>교체:</em> 기존 약국정보 삭제 후 신규 약국 등록<br>
            <em>유지:</em> 중복되지 않는 신규 약국만 등록 (기존 유지)
          </div>
        </div>
      </div>
    `
  },
  {
    label: '6. 매출 관리',
    content: `
      <div class="section">
        <h2>6. 매출 관리</h2>
        <h3>6.1 도매매출 관리 <span class="path">/admin/wholesale-revenue</span></h3>
        <p><strong>설명:</strong> 도매매출 데이터를 등록하고 관리할 수 있습니다.</p>
        
        <img src="/manual-images/admin_6_1_wholesale_sales_list.png" alt="도매매출 관리" class="manual-image">
        
        <h3>6.2 직거래매출 관리 <span class="path">/admin/direct-revenue</span></h3>
        <p><strong>설명:</strong> 직거래매출 데이터를 등록하고 관리할 수 있습니다.</p>
        
        <img src="/manual-images/admin_6_2_direct_sales_list.png" alt="직거래매출 관리" class="manual-image">
      </div>
    `
  },
  {
    label: '7. 실적 관리',
    content: `
      <div class="section">
        <h2>7. 실적 관리</h2>
        
        <h3>7.1 정산월 관리 <span class="path">/admin/settlement-months</span></h3>
        <p><strong>설명:</strong> 정산 작업을 수행할 기준 '정산월'을 생성하고 관리합니다. 정산월을 생성해야 해당 월의 실적 등록, 검수, 정산 절차를 시작할 수 있습니다.</p>
        <img src="/manual-images/admin_7_1_settlement_months.png" alt="정산월 관리" class="manual-image">
        <h4>주요 기능:</h4>
        <ul class="feature-list">
          <li><strong>신규 정산월 생성</strong> - 정산월명, 시작일, 종료일, 공지사항 설정</li>
          <li><strong>정산월별 상태 관리</strong> - 'active'(활성), 'inactive'(비활성) 상태 관리</li>
          <li><strong>정산월 정보 수정</strong> - 기존 정산월의 정보 수정 및 비고 추가</li>
          <li><strong>정산월 삭제</strong> - 더 이상 필요하지 않은 정산월 삭제</li>
        </ul>

        <h3>7.2 실적 등록 <span class="path">/admin/performance/register</span></h3>
        <p><strong>설명:</strong> 관리자가 CSO 업체 대신 실적 데이터를 직접 등록하거나, 기존 실적을 수정/추가/삭제할 수 있는 메뉴입니다. 주로 긴급 상황이나 데이터 오류 수정 시 사용됩니다.</p>
        <img src="/manual-images/admin_7_2_performance_regist.png" alt="실적 등록" class="manual-image">
        <h4>주요 기능:</h4>
        <ul class="feature-list">
          <li><strong>실적 데이터 직접 등록</strong> - 필요한 경우 관리자가 직접 실적 정보를 입력하고 저장</li>
          <li><strong>기존 실적 수정/삭제</strong> - 이미 등록된 실적 데이터를 검색하여 내용을 수정하거나 삭제</li>
          <li><strong>파일 업로드 지원</strong> - 증빙 자료 등의 파일을 첨부</li>
          <li><strong>유효성 검사</strong> - 데이터 입력 시 필수 항목 및 형식 유효성을 자동으로 검사</li>
        </ul>

        <h3>7.3 업체별 등록 현황 <span class="path">/admin/performance/companies</span></h3>
        <p><strong>설명:</strong> 정산월을 기준으로 CSO 업체별 실적 등록 현황을 모니터링합니다. 어느 업체가 실적을 제출했고, 어떤 상태인지 한눈에 파악할 수 있습니다.</p>
        <img src="/manual-images/admin_7_3_performance_company.png" alt="업체별 등록 현황" class="manual-image">
        <h4>주요 기능:</h4>
        <ul class="feature-list">
          <li><strong>정산월별 업체 현황</strong> - 선택한 정산월에 실적을 등록한 업체 목록 조회</li>
          <li><strong>실적 상태별 필터링</strong> - '대기', '검수중', '완료' 상태별로 업체 분류</li>
          <li><strong>업체별 실적 건수</strong> - 각 업체가 등록한 총 실적 건수 표시</li>
          <li><strong>실적 검수 바로가기</strong> - 업체명 클릭 시 해당 업체의 실적 검수 화면으로 이동</li>
        </ul>

        <h3>7.4 전체 등록 현황 <span class="path">/admin/performance/all</span></h3>
        <p><strong>설명:</strong> 모든 업체가 등록한 전체 실적 현황을 통합하여 조회하고 관리합니다.</p>
        <img src="/manual-images/admin_7_4_settlement_all.png" alt="전체 등록 현황" class="manual-image">
        <h4>주요 기능:</h4>
        <ul class="feature-list">
          <li><strong>다양한 필터링</strong> - 정산월, 처방월, 업체, 병의원, 검수상태별 필터링</li>
          <li><strong>실적 데이터 조회</strong> - 등록된 모든 실적 데이터 목록 확인</li>
          <li><strong>상세 정보 조회</strong> - 개별 실적 건에 대한 상세 정보 조회</li>
          <li><strong>대용량 데이터 처리</strong> - 1,000건 이상의 데이터도 안정적으로 조회</li>
        </ul>
      </div>
    `
  },
  {
    label: '8. 정산 관리',
    content: `
      <div class="section">
        <h2>8. 정산 관리</h2>

        <h3>8.1 실적 검수 <span class="path">/admin/performance-review</span></h3>
        <p><strong>설명:</strong> CSO 업체들이 등록한 실적 데이터를 건별로 상세히 검토하고 수정/추가/삭제 작업을 수행합니다. 이 과정을 통해 데이터의 정합성을 확보하고 정산의 기초 자료를 마련합니다.</p>
        <img src="/manual-images/admin_8_1_check.png" alt="실적 검수" class="manual-image">
        <h4>주요 기능:</h4>
        <ul class="feature-list">
          <li><strong>실적 데이터 불러오기</strong> - 정산월, 업체, 병의원 필터를 설정하여 '대기' 상태의 실적을 '검수중'으로 전환하고 조회</li>
          <li><strong>인라인 수정</strong> - 처방수량, 제품, 처방월, 비고 등을 직접 수정하여 저장</li>
          <li><strong>실적 추가</strong> - 기존 실적 아래에 새로운 실적을 추가하여 등록</li>
          <li><strong>검수 상태 관리</strong> - 검수 완료된 실적을 '완료' 상태로 변경하여 정산 대상에 포함</li>
          <li><strong>변경 이력 추적</strong> - 모든 수정/추가 작업이 별도 테이블에 이력으로 기록되어 추적 가능</li>
        </ul>
        
        <h4>검수 프로세스:</h4>
        <div class="process-steps">
          <div class="step">
            <strong>1단계: 실적 데이터 불러오기</strong><br>
            <em>필터 설정:</em> 정산월, 업체, 병의원 선택<br>
            <em>상태 선택:</em> '신규'(대기→검수중), '전체', '검수중', '완료'<br>
            <em>동작:</em> 선택된 조건의 실적 데이터를 화면에 로드
          </div>
          <div class="step">
            <strong>2단계: 실적 데이터 검토 및 수정</strong><br>
            <em>수정 방법:</em> 각 행의 '수정(✎)' 버튼 클릭 → 인라인 편집 모드<br>
            <em>수정 항목:</em> 처방수량, 제품, 처방월, 처방유형, 비고<br>
            <em>저장:</em> '저장(✓)' 버튼으로 변경사항 저장
          </div>
          <div class="step">
            <strong>3단계: 실적 추가 (필요시)</strong><br>
            <em>추가 방법:</em> 기존 행의 '+' 버튼 클릭 → 새 행 생성<br>
            <em>입력 항목:</em> 병의원, 제품, 처방수량, 처방월, 비고<br>
            <em>특징:</em> 추가된 실적은 관리자가 생성한 것으로 기록
          </div>
          <div class="step">
            <strong>4단계: 검수 완료 처리</strong><br>
            <em>선택:</em> 검수 완료된 실적들을 체크박스로 선택<br>
            <em>상태 변경:</em> '검수 상태 변경' 버튼으로 '완료'로 변경<br>
            <em>결과:</em> 완료된 실적은 흡수율 분석 및 정산 대상에 포함
          </div>
        </div>

        <h3>8.2 흡수율 분석 <span class="path">/admin/absorption-analysis</span></h3>
        <p><strong>설명:</strong> 검수가 '완료'된 실적 데이터를 기준으로, 제품별 처방액 대비 실제 매출(도매+직거래)의 비율을 분석합니다. 이를 통해 실적 목표 달성률과 효율성을 파악할 수 있습니다.</p>
        <img src="/manual-images/admin_8_2_absorption_analysis.png" alt="흡수율 분석" class="manual-image">
        <h4>주요 기능:</h4>
        <ul class="feature-list">
          <li><strong>필터링 및 조회</strong> - 정산월, 업체, 병의원별로 '완료' 상태의 실적 데이터 조회</li>
          <li><strong>흡수율 계산</strong> - '흡수율 분석' 버튼으로 도매/직거래 매출액 자동 계산 및 흡수율 산출</li>
          <li><strong>매출 매칭</strong> - 병의원-약국 매핑을 통한 정확한 매출 데이터 연결</li>
          <li><strong>분배 로직</strong> - 약국별 병원 수에 따른 매출 분배 계산</li>
          <li><strong>결과 표시</strong> - 합산액, 흡수율을 실시간으로 테이블에 업데이트</li>
        </ul>
        
        <h4>흡수율 계산 프로세스:</h4>
        <div class="process-steps">
          <div class="step">
            <strong>1단계: 완료된 실적 데이터 조회</strong><br>
            <em>조건:</em> review_status = '완료'인 실적만 대상<br>
            <em>필터:</em> 정산월, 업체, 병의원별 필터링<br>
            <em>결과:</em> 검수 완료된 실적 목록 표시
          </div>
          <div class="step">
            <strong>2단계: 매출 데이터 매칭</strong><br>
            <em>매칭 기준:</em> 병의원-약국 매핑 → 제품 표준코드 → 처방월<br>
            <em>매출 종류:</em> 도매매출(wholesale_sales) + 직거래매출(direct_sales)<br>
            <em>분배 로직:</em> 약국별 연결된 병원 수에 따른 매출 분배
          </div>
          <div class="step">
            <strong>3단계: 흡수율 계산</strong><br>
            <em>계산 공식:</em> (총 매출액 / 처방액) × 100<br>
            <em>결과:</em> 각 실적별 흡수율(%) 산출<br>
            <em>표시:</em> 테이블의 '합산액', '흡수율' 컬럼에 실시간 업데이트
          </div>
        </div>

        <h3>8.3 정산내역서 공유 <span class="path">/admin/settlement-share</span></h3>
        <p><strong>설명:</strong> 검수가 '완료'된 실적을 바탕으로 CSO 업체별 정산내역서를 생성하고 시스템을 통해 공유합니다. 업체는 공유된 내역서를 확인하고 다운로드할 수 있습니다.</p>
        <img src="/manual-images/admin_8_3_settlement_share.png" alt="정산내역서 공유" class="manual-image">
        <h4>주요 기능:</h4>
        <ul class="feature-list">
          <li><strong>정산월별 업체 합산</strong> - '완료' 상태 실적을 업체별로 자동 합산하여 정산내역서 생성</li>
          <li><strong>업체별 상세 조회</strong> - 각 업체의 정산내역서 상세 확인 <span class="path">/admin/settlement-share/:id</span></li>
          <li><strong>공유 상태 관리</strong> - 업체별로 정산내역서 공유 여부를 체크박스로 설정</li>
          <li><strong>실시간 업데이트</strong> - 공유 설정 변경 시 즉시 데이터베이스에 반영</li>
          <li><strong>업체 접근 제어</strong> - 공유된 업체만 해당 정산내역서 조회 가능</li>
        </ul>
        
        <h4>정산내역서 생성 프로세스:</h4>
        <div class="process-steps">
          <div class="step">
            <strong>1단계: 정산월 선택</strong><br>
            <em>선택:</em> 정산 대상 월을 드롭다운에서 선택<br>
            <em>조건:</em> 해당 월에 '완료' 상태 실적이 있는 업체만 표시<br>
            <em>결과:</em> 업체별 합산 데이터 자동 계산
          </div>
          <div class="step">
            <strong>2단계: 업체별 정산내역 확인</strong><br>
            <em>표시 항목:</em> 업체명, 병의원 수, 총 실적 건수, 총 처방액, 총 지급액<br>
            <em>공유 상태:</em> 각 업체별 공유 여부 체크박스<br>
            <em>상세 조회:</em> 업체명 클릭 시 상세 정산내역 확인
          </div>
          <div class="step">
            <strong>3단계: 공유 설정 및 저장</strong><br>
            <em>공유 설정:</em> 원하는 업체의 체크박스 선택<br>
            <em>저장:</em> '저장' 버튼으로 공유 상태 업데이트<br>
            <em>결과:</em> 공유된 업체는 해당 정산내역서 조회 가능
          </div>
        </div>
      </div>
    `
  }
];

// 이용자 탭 내용
const userTabs = [
  {
    label: '1. 공지사항 조회',
    content: `
      <div class="section">
        <h2>1. 공지사항 조회</h2>
        <h3>1.1 공지사항 조회 <span class="path">/notices</span></h3>
        <p><strong>설명:</strong> 관리자(제약사)의 주요 공지사항을 확인할 수 있습니다.</p>
        
        <img src="/manual-images/user_1_notice_list.png" alt="공지사항 조회" class="manual-image">
        
        <h4>주요 기능:</h4>
        <ul class="feature-list">
          <li><strong>공지사항 목록 조회</strong> - 관리자가 등록한 공지사항들을 제목, 작성일시, 조회수와 함께 목록 형태로 확인할 수 있습니다.</li>
          <li><strong>공지사항 상세 조회</strong> - 제목을 클릭하여 공지사항의 전체 내용을 상세히 확인할 수 있습니다.</li>
          <li><strong>고정 공지사항 확인</strong> - 중요한 공지사항은 목록 상단에 고정되어 우선적으로 확인할 수 있습니다.</li>
          <li><strong>첨부파일 다운로드</strong> - 공지사항에 첨부된 파일들을 다운로드하여 확인할 수 있습니다.</li>
          <li><strong>검색 기능</strong> - 제목이나 내용에서 원하는 키워드로 공지사항을 검색할 수 있습니다.</li>
        </ul>
      </div>
    `
  },
  {
    label: '2. 제품 조회',
    content: `
      <div class="section">
        <h2>2. 제품 조회</h2>
        <h3>2.1 제품 조회 <span class="path">/products</span></h3>
        <p><strong>설명:</strong> 제품 정보를 조회하고 상세 내용을 확인할 수 있습니다.</p>
        
        <img src="/manual-images/user_2_product_list.png" alt="제품 조회" class="manual-image">
        
        <h4>주요 기능:</h4>
        <ul class="feature-list">
          <li><strong>제품 목록 조회</strong> - 판매 가능한 제품들의 제품명, 보험코드, 가격, 표준코드 정보를 테이블 형태로 확인할 수 있습니다.</li>
          <li><strong>제품 상세 정보 조회</strong> - 특정 제품을 선택하여 상세한 제품 정보와 규격을 확인할 수 있습니다.</li>
          <li><strong>제품 검색</strong> - 제품명, 보험코드, 표준코드로 원하는 제품을 빠르게 검색할 수 있습니다.</li>
          <li><strong>정렬 기능</strong> - 제품명, 가격, 등록일 등 다양한 기준으로 목록을 정렬하여 확인할 수 있습니다.</li>
          <li><strong>필터링 기능</strong> - 제품 카테고리나 가격 범위 등으로 제품 목록을 필터링할 수 있습니다.</li>
        </ul>
      </div>
    `
  },
  {
    label: '3. 병의원 조회',
    content: `
      <div class="section">
        <h2>3. 병의원 조회</h2>
        <h3>3.1 병의원 조회 <span class="path">/clients</span></h3>
        <p><strong>설명:</strong> 담당 병의원 정보를 조회하고 상세 내용을 확인할 수 있습니다.</p>
        
        <img src="/manual-images/user_3_hospital_list.png" alt="병의원 조회" class="manual-image">
        
        <h4>주요 기능:</h4>
        <ul class="feature-list">
          <li><strong>병의원 목록 조회</strong> - 본인이 담당하는 병의원들의 병의원명, 사업자번호, 담당자, 연락처 정보를 확인할 수 있습니다.</li>
          <li><strong>병의원 상세 정보 조회</strong> - 특정 병의원을 선택하여 주소, 원장명, 진료과목 등 상세 정보를 확인할 수 있습니다.</li>
          <li><strong>병의원 검색</strong> - 병의원명이나 사업자번호로 담당 병의원을 빠르게 검색할 수 있습니다.</li>
          <li><strong>정렬 기능</strong> - 병의원명, 등록일, 지역 등 다양한 기준으로 목록을 정렬하여 확인할 수 있습니다.</li>
          <li><strong>필터링 기능</strong> - 지역이나 진료과목 등으로 병의원 목록을 필터링할 수 있습니다.</li>
        </ul>
      </div>
    `
  },
  {
    label: '4. 실적 관리',
    content: `
      <div class="section">
        <h2>4. 실적 관리</h2>
        <h3>4.1 실적 등록 <span class="path">/performance/register</span></h3>
        <p><strong>설명:</strong> 담당 병의원에 대한 실적 데이터를 등록할 수 있습니다.</p>
        
        <img src="/manual-images/user_4_1_edi.png" alt="실적 등록" class="manual-image">
        
        <h4>주요 기능:</h4>
        <ul class="feature-list">
          <li><strong>기본 정보 입력</strong> - 정산월, 처방월, 담당 병의원, 제품, 처방수량, 처방유형, 비고 등 실적의 기본 정보를 입력</li>
          <li><strong>증빙 파일 업로드</strong> - 처방전, 영수증 등 실적을 증명하는 파일을 업로드하여 관리</li>
          <li><strong>입력값 유효성 검사</strong> - 필수 항목 누락, 숫자 형식 오류 등을 자동으로 체크하여 정확한 데이터 입력</li>
          <li><strong>저장 시 확인 메시지</strong> - 실적 데이터 저장 전 입력 내용을 최종 확인할 수 있는 메시지 제공</li>
          <li><strong>실적 데이터 수정</strong> - 이미 등록된 실적 데이터를 선택하여 내용을 수정</li>
        </ul>

        <h3>4.2 등록 현황 <span class="path">/performance/list</span></h3>
        <p><strong>설명:</strong> 전체 등록한 실적 내용을 조회할 수 있습니다. 이번 달뿐 아니라 지난 내역까지 모두 확인할 수 있습니다.</p>
        
        <img src="/manual-images/user_4_2_edi.png" alt="등록 현황" class="manual-image">
        
        <h4>주요 기능:</h4>
        <ul class="feature-list">
          <li><strong>전체 실적 조회</strong> - 월 제한 없이 등록된 모든 실적 데이터를 확인</li>
          <li><strong>정산월별 필터링</strong> - 특정 정산월을 기준으로 실적 데이터를 필터링</li>
          <li><strong>처방월별 필터링</strong> - 특정 처방월을 기준으로 실적 데이터를 필터링</li>
          <li><strong>병의원별 필터링</strong> - 특정 병의원을 기준으로 실적 데이터를 필터링</li>
          <li><strong>실적 상세 조회</strong> - 각 실적 건의 상세 내용을 확인</li>
          <li><strong>실적 수정</strong> - 등록된 실적을 선택하여 내용 수정</li>
        </ul>
      </div>
    `
  },
  {
    label: '5. 정산내역서 조회',
    content: `
      <div class="section">
        <h2>5. 정산내역서 조회</h2>
        <h3>5.1 정산내역서 조회 <span class="path">/settlements</span></h3>
        <p><strong>설명:</strong> 공유된 정산내역서를 조회하고 다운로드할 수 있습니다.</p>
        
        <img src="/manual-images/user_5_1_payment.png" alt="정산내역서 조회" class="manual-image">
        
        <h4>주요 기능:</h4>
        <ul class="feature-list">
          <li><strong>정산내역서 목록 조회</strong> - 관리자가 공유한 월별 정산내역서를 년월, 정산액, 공유 상태와 함께 확인할 수 있습니다.</li>
          <li><strong>정산내역서 상세 조회</strong> - 특정 월의 정산내역서를 선택하여 상세한 정산 내용과 실적 데이터를 확인할 수 있습니다.</li>
          <li><strong>정산내역서 다운로드</strong> - 정산내역서를 PDF나 Excel 파일로 다운로드하여 보관할 수 있습니다.</li>
          <li><strong>정렬 기능</strong> - 정산월, 정산액, 공유일 등 다양한 기준으로 정산내역서 목록을 정렬할 수 있습니다.</li>
          <li><strong>필터링 기능</strong> - 특정 기간이나 정산액 범위로 정산내역서를 필터링하여 조회할 수 있습니다.</li>
        </ul>
      </div>
    `
  },
  {
    label: '6. 내 정보 관리',
    content: `
      <div class="section">
        <h2>6. 내 정보 관리</h2>
        <h3>6.1 내 정보 조회/수정 <span class="path">/my-info</span></h3>
        <p><strong>설명:</strong> 계정 정보를 조회하고 수정할 수 있습니다.</p>
        
        <img src="/manual-images/user_6_1_myinfo.png" alt="내 정보 조회/수정" class="manual-image">
        
        <h4>주요 기능:</h4>
        <ul class="feature-list">
          <li><strong>기본 정보 조회</strong> - 현재 등록된 업체명, 담당자명, 연락처, 이메일 등 기본 정보를 확인할 수 있습니다.</li>
          <li><strong>담당자 정보 수정</strong> - 담당자명, 부서, 직책 등의 담당자 정보를 수정할 수 있습니다.</li>
          <li><strong>연락처 수정</strong> - 휴대폰 번호, 사무실 전화번호, 팩스 번호 등을 수정할 수 있습니다.</li>
          <li><strong>이메일 수정</strong> - 로그인 시 사용하는 이메일 주소를 변경할 수 있습니다.</li>
          <li><strong>저장 시 확인 메시지</strong> - 정보 수정 후 저장 시 변경사항을 최종 확인할 수 있는 메시지를 제공합니다.</li>
        </ul>

        <h3>6.2 비밀번호 변경 <span class="path">/my-info/change-password</span></h3>
        <p><strong>설명:</strong> 계정 비밀번호를 변경할 수 있습니다.</p>
        
        <div class="image-placeholder">
          <div class="placeholder-text">📷 화면 이미지</div>
        </div>

        <img src="/manual-images/user_6_2_pw.png" alt="내 정보 조회/수정" class="manual-image">

        <h4>주요 기능:</h4>
        <ul class="feature-list">
          <li><strong>현재 비밀번호 확인</strong> - 보안을 위해 현재 사용 중인 비밀번호를 입력하여 본인 확인을 수행합니다.</li>
          <li><strong>새 비밀번호 입력</strong> - 보안 정책에 맞는 새로운 비밀번호를 입력할 수 있습니다.</li>
          <li><strong>비밀번호 변경</strong> - 입력된 새 비밀번호로 계정 비밀번호를 변경합니다.</li>
          <li><strong>입력값 유효성 검사</strong> - 비밀번호 강도, 길이, 특수문자 포함 여부 등을 자동으로 검사합니다.</li>
          <li><strong>변경 시 확인 메시지</strong> - 비밀번호 변경 완료 시 성공 여부를 확인할 수 있는 메시지를 제공합니다.</li>
        </ul>
      </div>
    `
  }
];

const tabs = computed(() => {
  return isAdminManual.value ? adminTabs : userTabs;
});
</script>

<style scoped>
.manual-container {
  height: 100vh;
  overflow-y: auto;
  background-color: #fff;
  padding: 0px;
  margin-left: 0px;
}

.manual-content {
  max-width: 1200px;
  margin: 0 auto;
  background: white;
  border-radius: 8px;
  box-shadow: 0 0px 0px rgba(0, 0, 0, 0);
  position: relative;
  overflow: visible;
}

.manual-header {
  position: sticky;
  top: 0;
  z-index: 1000;
  background: white;
  box-shadow: 0 0px 0px rgba(0,0,0,0);
  border-radius: 0px 0px 0px 0px;
  margin: 0;
}

.header-top {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 40px 40px 16px 40px;
}

h1 {
  color: #555;
  border-bottom: none;
  padding: 0;
  margin-top: 0.5rem;
  margin-bottom: 0.5rem;
  background: #fff;
  font-size: 24px;
  font-weight: 600;
}

.manual-tabs {
  display: flex;
  background: #fff;
  border-bottom: 1px solid #dee2e6;
  overflow-x: auto;
  padding: 0 20px;
}

.manual-tab {
  padding: 1rem 1.5rem;
  cursor: pointer;
  border-bottom: 2px solid transparent;
  white-space: nowrap;
  transition: all 0.3s ease;
  font-size: var(--font-size-lg);
  font-weight: 500;
  color: #999;
  flex-shrink: 0;
}

.manual-tab:hover {
  background-color: var(--primary-color-lightest);
  color: var(--primary-color);
}

.manual-tab.active {
  border-bottom-color: var(--primary-color);
  color: var(--primary-color);
  font-weight: 600;
  background-color: #fff;
}

.manual-html-content {
  font-family: 'Noto Sans KR', sans-serif;
  line-height: 1.6;
  color: #333;
  padding: 40px;
}

.manual-html-content :deep(.section) {
  margin-bottom: 30px;
  padding: 0px;
  background: #fff;
  border-radius: 5px;
}

.manual-html-content :deep(h2) {
  color: var(--primary-color);
  margin-top: 0;
  margin-bottom: 20px;
  font-size: 20px;
  font-weight: 600;
}

.manual-html-content :deep(h3) {
  color: #555;
  margin-top: 25px;
  margin-bottom: 15px;
  font-size: 18px;
  font-weight: 500;
}

.manual-html-content :deep(h4) {
  color: #333;
  margin-top: 20px;
  margin-bottom: 10px;
  font-size: 16px;
  font-weight: 500;
}

.manual-html-content :deep(.feature-list) {
  list-style-type: none;
  padding-left: 20px;
  margin: 15px 0;
}

.manual-html-content :deep(.feature-list li) {
  margin-bottom: 8px;
  position: relative;
  padding-left: 0;
}

.manual-html-content :deep(.feature-list li:before) {
  content: "•";
  color: var(--primary-color);
  font-weight: bold;
  position: absolute;
  left: -15px;
}

.manual-html-content :deep(.path) {
  color: #7f8c8d;
  font-family: 'Courier New', monospace;
  background: #f1f1f1;
  padding: 2px 6px;
  border-radius: 3px;
  font-size: 14px;
}

.manual-html-content :deep(p) {
  margin: 15px 0;
  line-height: 1.6;
}

.manual-html-content :deep(strong) {
  color: #2c3e50;
  font-weight: 600;
}

.manual-html-content :deep(.manual-image) {
  width: 100%;
  border: 1px solid #eee;
  border-radius: 8px;
  margin: 20px 0;
  box-shadow: 0 4px 8px rgba(0,0,0,0.05);
}

.manual-html-content :deep(.process-steps) {
  margin: 20px 0;
}

.manual-html-content :deep(.step) {
  background: #f8f9fa;
  border-left: 4px solid #3498db;
  padding: 15px 20px;
  margin-bottom: 15px;
  border-radius: 0 8px 8px 0;
  box-shadow: 0 2px 4px rgba(0,0,0,0.1);
}

.manual-html-content :deep(.step strong) {
  color: #2980b9;
  display: block;
  margin-bottom: 8px;
  font-size: 16px;
}

.manual-html-content :deep(.step em) {
  font-style: normal;
  font-weight: 600;
  color: #27ae60;
}

.pdf-download-button {
  font-weight: 400;
  font-size: 0.9rem;
}

:deep(.pdf-download-button .p-button-icon) {
  font-size: 1.25rem;
  margin-left: 0.5rem;
}

@media (max-width: 768px) {
  .manual-container {
    padding: 10px;
  }
  
  .manual-content {
    border-radius: 0;
  }
  
  h1 {
    font-size: 20px;
    padding: 15px 20px;
  }
  
  .manual-tabs {
    padding: 0 10px;
  }
  
  .manual-tab {
    padding: 12px 15px;
    font-size: 14px;
  }
  
  .manual-html-content :deep(.section) {
    padding: 15px;
  }
  
  .manual-html-content :deep(.image-placeholder) {
    height: 200px;
  }
}
</style> 