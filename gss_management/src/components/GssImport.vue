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
    <div v-if="csvData">
      <h3>CSVデータ:</h3>
      <pre>{{ csvData }}</pre>
    </div>
  </div>
</template>

<script lang="ts">
import { defineComponent, ref, onMounted } from 'vue';
import axios from 'axios';

export default defineComponent({
  setup() {
    const spreadsheetUrl = ref('');
    const errorMessage = ref('');
    const csvData = ref('');

    const submitUrl = async () => {
      try {
        const response = await axios.post('/api/gss', { url: spreadsheetUrl.value });
        csvData.value = response.data; // バックエンドからのCSVデータを保存
      } catch (error) {
        errorMessage.value = 'エラーが発生しました。URLを確認してください。';
      }
    };
    async function getGss () {
    try {
      console.log('getGss')
      const res = await axios.get('http://localhost:3000/')
      console.log(res.data)
    }
    catch (err) {
      console.log(err)
    }};
    onMounted(() => {
      getGss()
    });
    return {
      spreadsheetUrl,
      // submitUrl,
      csvData,
      errorMessage
    };
  }
});
</script>

<style scoped>
.error {
  color: red;
}
</style>
