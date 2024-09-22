import Vue from 'vue';
import App from './App.vue';
import router from './router';  

new Vue({
  router,  // ルーターを使用
  render: h => h(App)
}).$mount('#app');