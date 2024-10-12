<template>
  <div class="container">
    <h1 class="title">{{ message }}</h1>
    <ul v-if="tableNames.length > 0" class="table-list">
      <li v-for="(item, index) in tableNames" :key="index" class="table-item">
        {{ index + 1 }}. {{ item }}
        <button class="modal-button" @click="openModal(item)">詳細</button>
      </li>
    </ul>
    <div v-if="errorMessage" class="error">{{ errorMessage }}</div>

    <!-- モーダルコンポーネント -->
    <Modal v-if="isModalOpen" :tableData="selectedTableData" :isOpen="isModalOpen" @close="closeModal" />
  </div>
</template>

<script lang="ts">
import { defineComponent, ref, onMounted } from 'vue';
import axios from 'axios';
import Modal from './Modal.vue';
import { gssData } from '../types/gss';

export default defineComponent({
  components: {
    Modal
  },
  setup() {
    const message = 'テーブルの一覧:';
    const tableNames = ref<string[]>([]);
    const errorMessage = ref<string>('');
    const isModalOpen = ref<boolean>(false);
    const selectedTableData = ref<gssData>([]);

    const fetchTableNames = async () => {
      try {
        const response = await axios.get('http://localhost:3000/gss-import');
        tableNames.value = response.data.data;
      } catch (error) {
        errorMessage.value = 'エラーが発生しました。テーブル名を取得できませんでした。';
      }
    };

    const openModal = async (tableName: string) => {
      const response = await axios.get(`http://localhost:3000/gss-import/${tableName}`);
      selectedTableData.value = response.data.data;
      isModalOpen.value = true;
    };

    const closeModal = () => {
      isModalOpen.value = false;
      selectedTableData.value = [];
    };

    onMounted(fetchTableNames);

    return {
      message,
      tableNames,
      errorMessage,
      isModalOpen,
      selectedTableData,
      openModal,
      closeModal
    };
  }
});
</script>

<style scoped>
.container {
  max-width: 600px;
  margin: 0 auto;
  padding: 20px;
  font-family: Arial, sans-serif;
  background-color: #f9f9f9;
  border-radius: 8px;
  box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
}

.title {
  font-size: 24px;
  color: #333;
  margin-bottom: 15px;
}

.table-list {
  list-style-type: none;
  padding: 0;
}

.table-item {
  padding: 10px;
  border-bottom: 1px solid #ddd;
  display: flex; /* フレックスボックスを使用 */
  justify-content: space-between; /* 左右に分ける */
  align-items: center; /* 垂直に中央揃え */
  transition: background-color 0.3s;
}

.table-item:hover {
  background-color: #f1f1f1;
}

.modal-button {
  margin-left: 10px; /* ボタンとの間にマージン */
  padding: 5px 10px; /* パディング */
  background-color: #007BFF; /* ボタンの背景色 */
  color: white; /* ボタンの文字色 */
  border: none; /* ボタンのボーダーをなしに */
  border-radius: 4px; /* 角を丸める */
  cursor: pointer; /* カーソルをポインターに */
}

.modal-button:hover {
  background-color: #0056b3; /* ホバー時の色 */
}

.error {
  color: red; /* エラーメッセージの色 */
  margin-top: 20px; /* 上部マージンを追加 */
  font-weight: bold; /* 太字にする */
}
</style>
