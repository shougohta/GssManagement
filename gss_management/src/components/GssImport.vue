<template>
  <div class="gss-import">
    <h2>Google Spreadsheet URLを取り込む</h2>

    <!-- GoogleスプレッドシートのURLを入力するフォーム -->
    <form @submit.prevent="submitUrl">
      <label for="gss-url">Google SpreadsheetのURLを入力してください:</label>
      <input
        type="text"
        id="gss-url"
        v-model="spreadsheetUrl"
        placeholder="https://docs.google.com/spreadsheets/d/your-spreadsheet-id/"
      />
      <button type="submit">取り込む</button>
    </form>

    <!-- エラーや結果の表示 -->
    <div v-if="errorMessage" class="error">{{ errorMessage }}</div>
    <div v-if="gssData">
      <h3>CSVデータ:</h3>
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
import { defineComponent, ref } from 'vue';
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
.error {
  color: red;
}
.table-wrapper {
  max-height: 400px; /* 適切な高さを設定 */
  overflow-y: auto; /* 縦のスクロールを可能にする */
}

.custom-table {
  width: 100%;
  border-collapse: collapse;
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

.custom-table th {
  padding: 12px;
}
</style>
