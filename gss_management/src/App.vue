<template>
  <div id="app">
    <router-link to="/">ホーム</router-link> | 
    <router-link to="/gss-import">GSS取り込み</router-link>
    <router-view></router-view> <!-- コンポーネントの表示エリア -->
  </div>
</template>

<script lang="ts">
export default {
  name: 'App'
};
</script>