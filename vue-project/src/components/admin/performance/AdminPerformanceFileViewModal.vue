<template>
  <Dialog :visible="visible" :modal="true" :closable="false" :style="{ width: '700px' }">
    <template #header>
      <div class="modal-header">
        <h3>{{ companyName }}</h3>
        <button class="modal-close-btn" @click="$emit('close')">×</button>
      </div>
    </template>
    <div class="modal-body">
      <table class="file-list-table" style="width:100%">
        <thead>
          <tr>
            <th style="width:30%">병의원명</th>
            <th style="width:50%">파일명</th>
            <th style="width:20%">다운로드</th>
          </tr>
        </thead>
        <tbody>
          <tr v-for="(file, idx) in files" :key="file.id">
            <td>{{ file.hospitalName }}</td>
            <td>
              <a class="file-link" :href="file.url" target="_blank" rel="noopener">{{ file.fileName }}</a>
            </td>
            <td>
              <button class="p-button p-button-sm" @click="onDownload(file, idx)">
                다운로드
              </button>
            </td>
          </tr>
          <tr v-if="!files || files.length === 0">
            <td colspan="3" class="empty-message">첨부 파일이 없습니다.</td>
          </tr>
        </tbody>
      </table>
    </div>
    <template #footer>
      <div class="modal-footer">
        <button class="p-button p-button-secondary" @click="onDownloadAll" :disabled="!files || files.length === 0">전체 다운로드</button>
        <button class="p-button" @click="$emit('close')">닫기</button>
      </div>
    </template>
  </Dialog>
</template>

<script setup>
import { defineProps, defineEmits } from 'vue';
import Dialog from 'primevue/dialog';

const props = defineProps({
  visible: Boolean,
  companyName: String,
  files: {
    type: Array,
    default: () => []
  }
});
const emit = defineEmits(['close', 'download', 'download-all']);

function onDownload(file, idx) {
  emit('download', file, idx);
}
function onDownloadAll() {
  emit('download-all');
}
</script> 