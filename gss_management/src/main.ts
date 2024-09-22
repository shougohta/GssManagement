import Vue from 'vue';
import VueCompositionApi from '@vue/composition-api';
import App from './components/App.vue';
import router from './router';  

Vue.use(VueCompositionApi);

new Vue({
  router,  // ルーターを使用
  render: h => h(App)
}).$mount('#app');