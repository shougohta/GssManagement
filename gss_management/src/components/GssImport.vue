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
      <button type="submit" >取り込む</button>
    </form>

    <!-- エラーや結果の表示 -->
    <div v-if="errorMessage" class="error">{{ errorMessage }}</div>
    <div v-if="csvData">
      <h3>CSVデータ:</h3>
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
          <tr v-for="(item, index) in csvData" :key="item.id">
            <th scope="row">{{ index + 1 }}</th>
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
        const response = await axios.post('http://localhost:3000/gss-import', { url: spreadsheetUrl.value, range: ["sample!A:F"]});
        csvData.value = response.data.data; // バックエンドからのCSVデータを保存
        console.log("data.data",response.data.data)
      } catch (error) {
        errorMessage.value = 'エラーが発生しました。URLを確認してください。';
      }
    };
    // async function getGss () {
    // try {
    //   console.log('getGss')
    //   const res = await axios.get('http://localhost:3000/gss-import')
    //   console.log(res.data)
    // }
    // catch (err) {
    //   console.log(err)
    // }};
    // onMounted(() => {
    //   getGss()
    // });
    return {
      spreadsheetUrl,
      submitUrl,
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