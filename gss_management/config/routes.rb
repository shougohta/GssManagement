Rails.application.routes.draw do
  root 'index#index'
  get 'gss-import', to: 'spreadsheets_import#index'
  get 'gss-import/:table_name', to: 'spreadsheets_import#show'
  post 'gss-import', to: 'spreadsheets_import#update'
end