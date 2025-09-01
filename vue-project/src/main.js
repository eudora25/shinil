// import '@primevue/themes/aura/theme.css';
import 'primeicons/primeicons.css';

// 기타 전역 CSS
import '@/assets/buttons.css';
import './assets/main.css';

// JS/라이브러리 import
import { createApp } from 'vue';
import App from './App.vue';
import router from './router';

import PrimeVue from 'primevue/config';
import Aura from '@primevue/themes/aura';
import ConfirmationService from 'primevue/confirmationservice';
import ToastService from 'primevue/toastservice';

const app = createApp(App);

app.use(router);
app.use(PrimeVue, {
  theme: Aura,
  ripple: true,
  inputStyle: 'filled',
});

// PrimeVue 서비스 등록
app.use(ConfirmationService);
app.use(ToastService);

app.mount('#app');