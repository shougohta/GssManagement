Rails.application.routes.draw do
  root 'index#index'                   # ホームページへのルート
  # Vue.jsのルーティングを処理するキャッチオール
  get '*path', to: 'index#index'  # すべての未定義ルートをindex#indexに渡す
end