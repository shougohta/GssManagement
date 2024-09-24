Rails.application.routes.draw do
  root 'index#index'                   # ホームページへのルート
  post 'gss-import', to: 'spreadsheets_import#update'
end