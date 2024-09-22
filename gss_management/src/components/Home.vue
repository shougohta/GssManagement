<template>
  <div>
    <p>{{ message }}</p>
  </div>
</template>

<script lang="ts">
import { defineComponent } from 'vue';

export default defineComponent({
  setup() {
    const message = 'ボタンをクリックしてください';

    return {
      message,
    };
  }
});
</script>
