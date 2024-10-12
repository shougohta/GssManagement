<template>
  <div class="container">
    <h1 class="title">{{ message }}</h1>
    <ul v-if="tableNames.length > 0" class="table-list">
      <li v-for="(item, index) in tableNames" :key="index" class="table-item">
        {{ index + 1 }}. {{ item }}
      </li>
    </ul>
    <div v-if="errorMessage" class="error">{{ errorMessage }}</div>
  </div>
</template>

<script lang="ts">
import { defineComponent, ref, onMounted } from 'vue';
import axios from 'axios';

export default defineComponent({
  setup() {
    const message = 'テーブルの一覧:';
    const tableNames = ref<string[]>([]); // ナンバリング用のリスト
    const errorMessage = ref<string>(''); // エラーメッセージ

    const fetchTableNames = async () => {
      try {
        const response = await axios.get('http://localhost:3000/gss-import'); // バックエンドのURLに応じて変更
        tableNames.value = response.data.data; // バックエンドから取得したテーブル名を設定
      } catch (error) {
        errorMessage.value = 'エラーが発生しました。テーブル名を取得できませんでした。';
      }
    };

    // コンポーネントがマウントされたときにテーブル名を取得
    onMounted(fetchTableNames);

    return {
      message,
      tableNames,
      errorMessage
    };
  }
});
</script>

<style scoped>
.container {
  max-width: 600px; /* 最大幅を設定 */
  margin: 0 auto; /* 中央揃え */
  padding: 20px; /* パディングを追加 */
  font-family: Arial, sans-serif; /* フォントファミリーを指定 */
  background-color: #f9f9f9; /* 背景色を設定 */
  border-radius: 8px; /* 角を丸める */
  box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1); /* シャドウを追加 */
}

.title {
  font-size: 24px; /* タイトルのフォントサイズを設定 */
  color: #333; /* タイトルの色 */
  margin-bottom: 15px; /* タイトルとリストの間のマージン */
}

.table-list {
  list-style-type: none; /* リストスタイルをなしに */
  padding: 0; /* パディングをなしに */
}

.table-item {
  padding: 10px; /* アイテムにパディングを追加 */
  border-bottom: 1px solid #ddd; /* 下にボーダーを追加 */
  transition: background-color 0.3s; /* ホバー効果のトランジション */
}

.table-item:hover {
  background-color: #f1f1f1; /* ホバー時の背景色 */
}

.error {
  color: red; /* エラーメッセージの色 */
  margin-top: 20px; /* 上部マージンを追加 */
  font-weight: bold; /* 太字にする */
}
</style>
