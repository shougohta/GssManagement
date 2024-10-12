<template>
  <div class="modal-overlay" @click.self="closeModal">
    <div class="modal-content">
      <h2 class="modal-title">テーブル内容</h2>
      <DataTable :data="tableData" /> <!-- テーブルコンポーネントを使用 -->
      <button class="close-button" @click="closeModal">閉じる</button>
    </div>
  </div>
</template>

<script lang="ts">
import { defineComponent, PropType } from 'vue';
import DataTable from './DataTable.vue'; // テーブルコンポーネントをインポート
import { gssData } from '../types/gss';

export default defineComponent({
  components: {
    DataTable
  },
  props: {
    tableData: {
      type: Array as PropType<gssData>, 
      required: true
    },
    isOpen: {
      type: Boolean,
      required: true
    }
  },
  emits: ['close'],
  methods: {
    closeModal() {
      this.$emit('close'); // モーダルを閉じるイベントを発火
    }
  }
});
</script>

<style scoped>
.modal-overlay {
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background-color: rgba(0, 0, 0, 0.5);
  display: flex;
  justify-content: center;
  align-items: center;
  z-index: 1000;
}

.modal-content {
  background-color: white;
  padding: 20px;
  border-radius: 8px;
  width: 600px; /* モーダルの幅を設定 */
  box-shadow: 0 2px 10px rgba(0, 0, 0, 0.2);
}

.modal-title {
  margin-bottom: 15px; /* タイトルの下にマージン */
}

.close-button {
  padding: 5px 10px; /* ボタンのパディング */
  background-color: #f44336; /* 閉じるボタンの色 */
  color: white; /* ボタンの文字色 */
  border: none; /* ボタンのボーダーをなしに */
  border-radius: 4px; /* 角を丸める */
  cursor: pointer; /* カーソルをポインターに */
}

.close-button:hover {
  background-color: #d32f2f; /* ホバー時の色 */
}
</style>
