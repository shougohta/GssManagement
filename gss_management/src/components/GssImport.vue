<template>
  <div class="gss-import container">
    <h2 class="title">Google Spreadsheet URLを取り込む</h2>

    <!-- GoogleスプレッドシートのURLを入力するフォーム -->
    <form @submit.prevent="submitUrl" class="url-form">  
      <label for="gss-name">スプレッドシート名称を入力してください:</label>
      <input
        type="text"
        id="gss-name"
        v-model="spreadsheetName"
        placeholder="スプレッドシート名称"
        class="input-url"
      />
      <label for="gss-url">Google SpreadsheetのURLを入力してください:</label>
      <input
        type="text"
        id="gss-url"
        v-model="spreadsheetUrl"
        placeholder="https://docs.google.com/spreadsheets/d/your-spreadsheet-id/"
        class="input-url"
      />
      <button type="submit" class="submit-button">取り込む</button>
    </form>

    <!-- エラーや結果の表示 -->
    <div v-if="errorMessage" class="error">{{ errorMessage }}</div>
    
    <div v-if="gssData.length > 0">
      <h3 class="data-title">CSVデータ:</h3>
      <DataTable :data="gssData" /> <!-- テーブルコンポーネントを使用 -->
    </div>
  </div>
</template>

<script lang="ts">
import { defineComponent, ref, onMounted } from 'vue';
import axios from 'axios';
import DataTable from '../components/DataTable.vue'; // テーブルコンポーネントをインポート
import { gssData } from '../types/gss';

export default defineComponent({
  components: {
    DataTable
  },
  setup() {
    const spreadsheetUrl = ref('');
    const spreadsheetName = ref(''); // スプレッドシート名称のための ref を追加
    const errorMessage = ref('');
    const gssData = ref<gssData>([]);

    const submitUrl = async () => {
      // 名称とURLの両方が入力されているか確認
      if (!spreadsheetUrl.value || !spreadsheetName.value) {
        errorMessage.value = 'スプレッドシート名称とURLの両方を入力してください。';
        return;
      }

      try {
        // テーブル名としてスプレッドシート名称をリクエストパラメータに追加
        const response = await axios.post('http://localhost:3000/gss-import', { 
          url: spreadsheetUrl.value, 
          name: spreadsheetName.value, // テーブル名を追加
          range: ["sample!A:F"]
        });
        gssData.value = response.data.data; // バックエンドからのCSVデータを保存
      } catch (error) {
        errorMessage.value = 'エラーが発生しました。URLを確認してください。';
      }
    };

    onMounted(() => {
      console.log("onMounted");
      console.log(gssData.value);
    });

    return {
      spreadsheetUrl,
      spreadsheetName, // 新しく追加したrefを返す
      submitUrl,
      gssData,
      errorMessage
    };
  }
});
</script>

<style scoped>
/* 以前のスタイルをそのまま使用 */
.container {
  max-width: 600px; /* 最大幅を設定 */
  margin: 50px auto; /* 中央揃え */
  padding: 20px; /* パディングを追加 */
  font-family: Arial, sans-serif; /* フォントファミリーを指定 */
  background-color: #f9f9f9; /* 背景色を設定 */
  border-radius: 8px; /* 角を丸める */
  box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1); /* シャドウを追加 */
}

.title {
  font-size: 24px; /* タイトルのフォントサイズを設定 */
  color: #333; /* タイトルの色 */
  margin-bottom: 15px; /* タイトルとフォームの間のマージン */
}

.url-form {
  margin-bottom: 20px; /* フォームと結果の間のマージン */
}

.input-url {
  width: 100%; /* 入力フィールドの幅を100%に */
  padding: 10px; /* パディングを追加 */
  border: 1px solid #ccc; /* ボーダーを設定 */
  border-radius: 4px; /* 角を丸める */
  margin-bottom: 10px; /* ボタンとの間のマージン */
}

.submit-button {
  padding: 10px 15px; /* ボタンのパディング */
  background-color: #007BFF; /* ボタンの背景色 */
  color: white; /* ボタンの文字色 */
  border: none; /* ボタンのボーダーをなしに */
  border-radius: 4px; /* 角を丸める */
  cursor: pointer; /* カーソルをポインターに */
}

.submit-button:hover {
  background-color: #0056b3; /* ホバー時の背景色 */
}

.error {
  color: red; /* エラーメッセージの色 */
  margin-top: 20px; /* 上部マージンを追加 */
  font-weight: bold; /* 太字にする */
}

.data-title {
  font-size: 20px; /* データタイトルのフォントサイズ */
  margin-top: 20px; /* データタイトルの上部マージン */
}
</style>
