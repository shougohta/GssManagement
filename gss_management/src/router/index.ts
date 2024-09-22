import Vue from 'vue';
import Router from 'vue-router';
import Home from '../components/Home.vue';
import GssImport from '../components/GssImport.vue';

// VueにRouterを適用
Vue.use(Router);

export default new Router({
  mode: 'history',
  routes: [
    { path: '/', component: Home },
    { path: '/gss-import', component: GssImport }
  ]
});
