<template>
  <div class="container">
    <h1 class="title">{{ message }}</h1>
    <ul v-if="tableNames.length > 0" class="table-list">
      <li v-for="(item, index) in tableNames" :key="index" class="table-item">
        {{ index + 1 }}. {{ item }}
        <div class="button-container">
          <button class="modal-button" @click="openModal(item)">詳細</button>
          <button class="delete-button" @click="deleteTable(item)">削除</button>
        </div>
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

    const deleteTable = async (tableName: string) => {
      try {
        await axios.delete(`http://localhost:3000/gss-import/${tableName}`);
        // 削除成功後、tableNamesから削除されたテーブル名を取り除く
        tableNames.value = tableNames.value.filter(item => item !== tableName);
      } catch (error) {
        errorMessage.value = '削除中にエラーが発生しました。';
      }
    };

    onMounted(fetchTableNames);

    return {
      message,
      tableNames,
      errorMessage,
      isModalOpen,
      selectedTableData,
      openModal,
      closeModal,
      deleteTable
    };
  }
});
</script>

<style scoped>
.container {
  max-width: 600px;
  margin: 50px auto;
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
  align-items: center; /* 垂直に中央揃え */
  transition: background-color 0.3s;
}

.table-item:hover {
  background-color: #f1f1f1;
}

.button-container {
  display: flex;
  justify-content: flex-end; /* ボタンを右寄せ */
  flex-grow: 1; /* リストアイテム全体が可能な限りのスペースを取る */
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

.delete-button {
  margin-left: 10px; /* ボタンとの間にマージン */
  padding: 5px 10px; /* パディング */
  background-color: #dc3545;
  color: white;
  border: none;
  border-radius: 4px;
  cursor: pointer;
}

.modal-button:hover {
  background-color: #0056b3; /* ホバー時の色 */
}

.delete-button:hover {
  background-color: #c82333; /* ホバー時の色 */
}

.error {
  color: red; /* エラーメッセージの色 */
  margin-top: 20px; /* 上部マージンを追加 */
  font-weight: bold; /* 太字にする */
}
</style>
