<template>
  <div class="gss-import container">
    <h2 class="title">Google Spreadsheet URLを取り込む</h2>

    <!-- GoogleスプレッドシートのURLを入力するフォーム -->
    <form @submit.prevent="submitUrl" class="url-form">  
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
      <div class="table-wrapper">
        <table class="custom-table">
          <thead>
            <tr>
              <th scope="col">#</th>
              <th scope="col">名前</th>
              <th scope="col">性別</th>
              <th scope="col">学年</th>
              <th scope="col">出身地</th>
              <th scope="col">専攻</th>
              <th scope="col">課外活動</th>
            </tr>
          </thead>
          <tbody>
            <tr v-for="(item) in gssData" :key="item.id">
              <td>{{ item.id }}</td>
              <td>{{ item.student_name }}</td>
              <td>{{ item.gender }}</td>
              <td>{{ item.class_level }}</td>
              <td>{{ item.home_state }}</td>
              <td>{{ item.major }}</td>
              <td>{{ item.extracurricular_activity }}</td>
            </tr>
          </tbody>
        </table>
      </div>
    </div>
  </div>
</template>

<script lang="ts">
import { defineComponent, onMounted, ref } from 'vue';
import axios from 'axios';
import { gssData } from '../types/gss';

export default defineComponent({
  setup() {
    const spreadsheetUrl = ref('');
    const errorMessage = ref('');
    const gssData = ref<gssData>([]);

    const submitUrl = async () => {
      try {
        const response = await axios.post('http://localhost:3000/gss-import', { url: spreadsheetUrl.value, range: ["sample!A:F"]});
        gssData.value = response.data.data; // バックエンドからのCSVデータを保存
        console.log("data.data", response.data.data);
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
      submitUrl,
      gssData,
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

.table-wrapper {
  max-height: 400px; /* 適切な高さを設定 */
  overflow-y: auto; /* 縦のスクロールを可能にする */
}

.custom-table {
  width: 100%;
  border-collapse: collapse;
  margin-top: 10px; /* テーブルとタイトルの間のマージン */
}

.custom-table th,
.custom-table td {
  border: 1px solid #ddd;
  padding: 8px;
}

.custom-table th {
  background-color: #f2f2f2;
  text-align: left;
  position: sticky;
  top: 0; /* ヘッダーの位置を固定 */
  z-index: 1; /* スクロール時に他のコンテンツの後ろに隠れないようにする */
}

.custom-table tr:nth-child(even) {
  background-color: #f9f9f9;
}

.custom-table tr:hover {
  background-color: #f1f1f1;
}
</style>
