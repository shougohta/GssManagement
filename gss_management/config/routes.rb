Rails.application.routes.draw do
  root 'index#index'
  get 'gss-import', to: 'spreadsheets_import#index'
  post 'gss-import', to: 'spreadsheets_import#update'
end