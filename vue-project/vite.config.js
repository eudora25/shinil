import { fileURLToPath, URL } from 'node:url'

import { defineConfig } from 'vite'
import vue from '@vitejs/plugin-vue'
import vueDevTools from 'vite-plugin-vue-devtools'

// https://vite.dev/config/
export default defineConfig({
  plugins: [
    vue(),
    vueDevTools(),
  ],
  resolve: {
    alias: {
      '@': fileURLToPath(new URL('./src', import.meta.url))
    },
  },
  optimizeDeps: {
    include: ['primevue/api', 'jszip', 'exceljs'],
  },
  build: {
    outDir: 'dist',
    assetsDir: 'assets',
    chunkSizeWarningLimit: 1000,
    rollupOptions: {
      output: {
        manualChunks: {
          vendor: ['vue', 'vue-router'],
          primevue: ['primevue'],
          editor: ['@ckeditor/ckeditor5-build-classic', 'quill'],
          utils: ['exceljs', 'jszip', 'file-saver', 'html2canvas', 'jspdf'],
          supabase: ['@supabase/supabase-js'],
        },
      },
    },
  },
  base: '/'
})
