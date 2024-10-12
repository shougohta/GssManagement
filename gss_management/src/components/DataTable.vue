<template>
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
        <tr v-for="(item, index) in data" :key="item.id">
          <td>{{ index + 1 }}</td>
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
</template>

<script lang="ts">
import { defineComponent, PropType } from 'vue';
import { gssData } from '../types/gss'; // gssDataの型をインポート

export default defineComponent({
  props: {
    data: {
      type: Array as PropType<gssData>, // GssData型の配列
      required: true,
    },
  },
});
</script>

<style scoped>
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
