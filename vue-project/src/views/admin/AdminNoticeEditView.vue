<template>
  <TopNavigationBar :breadcrumbMenu="'공지사항'" :breadcrumbSubMenu="'공지사항 수정'" />
  <div class="board_960">
    <div class="form-title">공지사항 수정</div>
    <form @submit.prevent="handleSubmit" class="notice-form single-row-form">
      <div class="form-row">
        <div class="form-col label-col label-60">
          <label style="text-align: right;">제목 <span class="required">*</span></label>
        </div>
        <div class="form-col input-col input-400">
          <input v-model="title" type="text" required />
        </div>
      </div>
      <div class="form-row">
        <div class="form-col label-col label-60">
          <label style="text-align: right;">내용 <span class="required">*</span></label>
        </div>
        <div class="form-col input-col input-400">
          <textarea v-model="content" ref="contentArea" rows="12" required @input="adjustTextareaHeight"></textarea>
        </div>
      </div>
      <div class="form-row">
        <div class="form-col label-col label-60">
          <label style="text-align: right;">필수</label>
        </div>
        <div class="form-col input-col input-400">
          <input type="checkbox" v-model="isRequired" id="requiredCheck" style="width:16px;height:16px;vertical-align:middle;" />
        </div>
      </div>
      <div class="form-row" style="align-items:flex-start;">
        <div class="form-col label-col label-60" style="padding-top:8px;">
          <label style="text-align: right;">파일 첨부</label>
        </div>
        <div class="form-col input-col input-400">
          <label class="file-upload-label" style="display:inline-block;cursor:pointer;background:#eee;padding:6px 18px;border-radius:4px;font-size:15px;">
            파일 선택
            <input type="file" multiple @change="onFileChange" class="file-upload-input" style="display:none;" />
          </label>
          <div v-if="files.length" style="margin-top:6px;">
            <div v-for="(f, idx) in files" :key="f.name + idx" style="display:flex;align-items:center;margin-bottom:2px;">
              <button type="button" class="btn-delete-sm" @click="removeFile(idx)">삭제</button>
              <span style="flex:1;white-space:nowrap;overflow:hidden;text-overflow:ellipsis;">{{ f.name }}</span>
            </div>
          </div>
        </div>
      </div>
      <div class="btn-row" style="justify-content: flex-end; margin-top: 1.2rem">
        <button class="btn-cancel" type="button" @click="goDetail">취소</button>
        <button class="btn-save" type="submit">저장</button>
      </div>
    </form>
  </div>
</template>

<script setup>
import { ref, onMounted, watch, nextTick } from 'vue';
import { useRoute, useRouter } from 'vue-router';
import { supabase } from '@/supabase';

const route = useRoute();
const router = useRouter();
const title = ref('');
const content = ref('');
const contentArea = ref(null);
const isPinned = ref(false);
const files = ref([]);
const fileInput = ref(null);

const adjustTextareaHeight = () => {
  if (contentArea.value) {
    contentArea.value.style.height = 'auto';
    contentArea.value.style.height = `${contentArea.value.scrollHeight}px`;
  }
};

onMounted(async () => {
  const { data, error } = await supabase
    .from('notices')
    .select('*')
    .eq('id', route.params.id)
    .single();
  if (error) {
    alert('데이터 로드 실패: ' + error.message);
    router.push('/admin/notices');
    return;
  }
  title.value = data.title;
  content.value = data.content;
  isPinned.value = data.is_pinned;
  if (data.file_url) {
    let fileUrls = [];
    if (typeof data.file_url === 'string') {
      try {
        fileUrls = JSON.parse(data.file_url);
      } catch {
        fileUrls = [data.file_url];
      }
    } else if (Array.isArray(data.file_url)) {
      fileUrls = data.file_url;
    }
    files.value = fileUrls.map(url => ({
      name: getFileName(url),
      url: url
    }));
  }
  nextTick(adjustTextareaHeight);
});

watch(content, () => {
  nextTick(adjustTextareaHeight);
});

function getFileName(url) {
  if (!url) return '';
  try {
    const fileName = url.split('/').pop();
    const decodedName = decodeURIComponent(fileName);
    return decodedName.replace(/^[0-9]+_/, '');
  } catch {
    return url;
  }
}

function onFileChange(e) {
  const selected = Array.from(e.target.files);
  files.value = files.value.concat(selected).slice(0, 10);
  e.target.value = '';
}

function removeFile(idx) {
  files.value.splice(idx, 1);
}

const handleSubmit = async () => {
  if (!title.value.trim() || !content.value.trim()) {
    alert('제목과 내용을 입력하세요.');
    return;
  }
  let fileUrls = files.value.map(f => f.url || '');
  for (const f of files.value) {
    if (!f.url) {
      const safeName = f.name.replace(/[^a-zA-Z0-9._-]/g, '_');
      const filePath = `attachments/${Date.now()}_${safeName}`;
      const { data, error } = await supabase.storage
        .from('notices')
        .upload(filePath, f);
      if (error) {
        alert('파일 업로드 실패: ' + error.message);
        return;
      }
      const url = data?.path
        ? supabase.storage.from('notices').getPublicUrl(data.path).data.publicUrl
        : null;
      fileUrls.push(url);
    }
  }
  const { error: updateError } = await supabase
    .from('notices')
    .update({
      title: title.value,
      content: content.value,
      is_pinned: isPinned.value,
      file_url: fileUrls
    })
    .eq('id', route.params.id);
  if (updateError) {
    alert('수정 실패: ' + updateError.message);
  } else {
    alert('수정되었습니다.');
    router.push('/admin/notices');
  }
};

function goDetail() {
  router.push(`/admin/notices/${route.params.id}`);
}
</script>

