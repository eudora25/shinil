<template>
  <div class="board_640">
    <div class="form-title">내 정보 수정</div>
    <form @submit.prevent="handleSubmit" class="notice-form grid-form">
      <div class="form-row">
        <div class="form-col">
          <label>아이디(이메일)</label>
          <input :value="email" readonly disabled class="input-uneditable" />
        </div>
        <div class="form-col"></div>
        <div class="form-col"></div>
      </div>
      <div class="form-row">
        <div class="form-col">
          <label>업체명 <span class="required">*</span></label>
          <input v-model="companyName" type="text" required />
        </div>
        <div class="form-col">
          <label>사업자등록번호 <span class="required">*</span></label>
          <input v-model="businessNumber" type="text" required />
        </div>
        <div class="form-col">
          <label>대표자명 <span class="required">*</span></label>
          <input v-model="representative" type="text" required />
        </div>
      </div>
      <div class="form-row">
        <div class="form-col col-2">
          <label>사업장 소재지 <span class="required">*</span></label>
          <input v-model="address" type="text" required />
        </div>
        <div class="form-col">
          <label>담당자명 <span class="required">*</span></label>
          <input v-model="contactPerson" type="text" required />
        </div>
      </div>
      <div class="form-row">
        <div class="form-col">
          <label>휴대폰번호 <span class="required">*</span></label>
          <input v-model="mobile" type="text" required />
        </div>
        <div class="form-col"></div>
        <div class="form-col"></div>
      </div>
      
      <div class="btn-row" style="justify-content: flex-end; margin-top: 1.2rem;">
        <button class="btn-cancel" type="button" @click="goBack">취소</button>
        <button class="btn-save" type="submit">저장</button>
      </div>
    </form>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import { supabase } from '@/supabase'

const router = useRouter()
const loading = ref(false)

const email = ref('')
const companyName = ref('')
const businessNumber = ref('')
const representative = ref('')
const address = ref('')
const contactPerson = ref('')
const mobile = ref('')
const companyId = ref(null)

onMounted(async () => {
  try {
    // 현재 사용자 정보 가져오기
    const { data: { session } } = await supabase.auth.getSession()
    if (!session?.user) {
      router.push('/login')
      return
    }

    // 사용자의 회사 정보 조회
    const { data, error } = await supabase
      .from('companies')
      .select('*')
      .eq('user_id', session.user.id)
      .single()
      
    if (error) {
      console.error('사용자 정보 조회 오류:', error)
      alert('사용자 정보를 불러올 수 없습니다.')
      return
    }
    
    if (data) {
      companyId.value = data.id
      email.value = data.email || ''
      companyName.value = data.company_name || ''
      businessNumber.value = data.business_registration_number || ''
      representative.value = data.representative_name || ''
      address.value = data.business_address || ''
      contactPerson.value = data.contact_person_name || ''
      mobile.value = data.mobile_phone || ''
    }
  } catch (err) {
    console.error('사용자 정보 조회 예외:', err)
    alert('사용자 정보를 불러오는 중 오류가 발생했습니다.')
  }
})

function goBack() {
  router.push('/my-info')
}

const handleSubmit = async () => {
  if (loading.value) return
  loading.value = true
  
  try {
    const currentUser = await supabase.auth.getUser();
    if (!currentUser.data.user) {
      alert('로그인 정보가 없습니다. 다시 로그인해주세요.');
      loading.value = false;
      return;
    }
    const currentUserId = currentUser.data.user.id;

    const { error } = await supabase
      .from('companies')
      .update({
        company_name: companyName.value,
        business_registration_number: businessNumber.value,
        representative_name: representative.value,
        business_address: address.value,
        contact_person_name: contactPerson.value,
        mobile_phone: mobile.value,
        updated_at: new Date().toISOString(),
        updated_by: currentUserId
      })
      .eq('id', companyId.value)
      
    if (error) {
      alert('수정 실패: ' + error.message)
      return
    }
    
    alert('수정되었습니다.')
    router.push('/my-info')
    
  } catch (err) {
    console.error('수정 오류:', err)
    alert('수정 중 오류가 발생했습니다: ' + (err.message || err))
  } finally {
    loading.value = false
  }
}
</script> 