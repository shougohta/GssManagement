<template>
  <div id="app">
    <nav class="top-bar">
      <div class="top-bar-left">GSS管理くん</div>
      <div class="top-bar-right">
        <router-link to="/" class="nav-link" exact-active-class="active">ホーム</router-link>
        <span class="separator">|</span>
        <router-link to="/gss-import" class="nav-link" active-class="active">GSS取り込み</router-link>
      </div>
    </nav>
    <router-view></router-view> <!-- コンポーネントの表示エリア -->
  </div>
</template>

<script lang="ts">
export default {
  name: 'App'
};
</script>

<style scoped>
.top-bar-left {
  font-size: 1.5em; /* フォントサイズを大きく */
  color: white; /* 文字色 */
}

.top-bar {
  display: flex;
  align-items: center; /* 縦方向の中央揃え */
  background-color: #007BFF; /* トップバーの背景色 */
  padding: 10px 20px; /* パディングを追加 */
  color: white; /* 文字色 */
  font-family: Arial, sans-serif; /* フォントファミリー */
}

.top-bar-right {
  margin-left: auto; /* 右側に余白を追加し、右寄せ */
  display: flex; /* フレックスボックスを使用 */
  gap: 10px; /* リンクの間に隙間を追加 */
}

.nav-link {
  color: white; /* リンクの文字色 */
  text-decoration: none; /* 下線を消す */
  padding: 5px 10px; /* リンクのパディング */
  border-radius: 4px; /* 角を丸める */
  transition: background-color 0.3s; /* ホバー時のスムーズな変化 */
}

.nav-link:hover {
  background-color: rgba(255, 255, 255, 0.2); /* ホバー時の背景色 */
}

.nav-link.active {
  background-color: rgba(255, 255, 255, 0.2); /* アクティブリンクの背景色 */
  font-weight: bold; /* アクティブリンクの文字を太字にする */
}

.separator {
  display: flex;
  color: white; /* セパレーターの色 */
  margin: 0 10px; /* セパレーターの左右にマージンを追加 */
  font-size: 1.2em;
  align-items: center;
}
</style>
