<template>
  <header class="top-nav">
    <div class="top-nav-breadcrumb">
      <span class="breadcrumb-menu">{{ menu }}</span>
      <span class="breadcrumb-sep" v-if="submenu">&gt;</span>
      <span class="breadcrumb-submenu">{{ submenu }}</span>
    </div>
  </header>
</template>

<script setup>
import { computed } from 'vue';
import { useRoute } from 'vue-router';

const route = useRoute();

const menu = computed(() => route.meta.menu || '');
const submenu = computed(() => route.meta.submenu || '');
</script>
