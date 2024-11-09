# 開発概要
⚫︎アプリ名
GSS一括管理くん

⚫︎機能概要
1. GSSを取り込める
    1. Rails
    2. Google APIでCSVとして取得
    3. S3にCSV保存
    4. MySQLにデータテーブルとして保存
        1.  MySQLはdocker管理
2. GSSを表示できる
    1. Vue
    2. テーブル形式をそのまま表示
3. バッチサーバーでdaemonのタスクとしてGSSの更新を実行
    1. タスクテーブルを作る
    2. GSSの更新をdaemonとして定義する

⚫︎その他使いたいもの

・rspec
・vue2, composition API
・stroe, vueX
・typescript


# GSS一括管理くん アプリ開発手順

## 1. Railsプロジェクトのセットアップ
手順:
Railsのプロジェクトを作成します。
Google APIと連携するための設定を行います。
CSVデータをMySQLに保存するためのモデルやマイグレーションを作成します。
DockerでMySQLのセットアップを行います。

```bash
# Railsプロジェクトの作成
rails new gss_management --api -d mysql

# Gemfileに必要なGemを追加
# google-api-client, aws-sdk-s3を追加
bundle add google-api-client aws-sdk-s3

# Docker用の設定ファイルを追加
touch Dockerfile
touch docker-compose.yml

# MySQL用のコンテナを起動
docker-compose up -d

# データベースを作成
docker-compose run web rake db:create

```


docker-compose.yml の例:

```yml


version: '3'
services:
  db:
    image: mysql:5.7
    environment:
      MYSQL_ROOT_PASSWORD: password
      MYSQL_DATABASE: gss_development
    ports:
      - "3306:3306"
  web:
    build: .
    command: bundle exec rails s -b '0.0.0.0'
    volumes:
      - ".:/myapp"
    ports:
      - "3000:3000"
    depends_on:
      - db
```

## 2. Google APIを使用してGSSデータを取得

手順:
Google Cloud Consoleでプロジェクトを作成し、APIキーを取得。
google-api-clientを使ってGoogle Sheetsのデータを取得。
データをCSV形式で保存し、S3にアップロード。
コード例:
Google APIの認証設定:
```bash
コードをコピーする
# Google APIのクレデンシャルを保存
touch config/credentials.json
```

Google Sheets APIのセットアップ:

```ruby
コードをコピーする
require 'google/apis/sheets_v4'

# Google Sheets APIをセットアップ
service = Google::Apis::SheetsV4::SheetsService.new
service.key = ENV['GOOGLE_API_KEY']

spreadsheet_id = 'your_spreadsheet_id'
range = 'Sheet1!A1:Z1000'

# データを取得
response = service.get_spreadsheet_values(spreadsheet_id, range)

```

CSV保存とS3アップロード:

```ruby
コードをコピーする
require 'csv'
require 'aws-sdk-s3'

# CSVファイル作成
csv_data = CSV.generate do |csv|
  response.values.each { |row| csv << row }
end

# S3アップロード
s3 = Aws::S3::Resource.new(region: 'ap-northeast-1')
obj = s3.bucket('your_bucket_name').object('gss_data.csv')
obj.put(body: csv_data)
```

## 3. MySQLにCSVデータを保存

手順:
CSVデータをMySQLに保存するモデルとマイグレーションを作成。
CSVをパースし、データベースに保存。
コマンド:

```bash
コードをコピーする
# モデルとマイグレーションの作成
rails generate model GssData name:string value:string
rails db:migrate
```
コード例:
```ruby
コードをコピーする
CSV.parse(csv_data, headers: true) do |row|
  GssData.create!(name: row['name'], value: row['value'])
end
```

4. Vue.jsとRailsの連携、データ表示（Composition API使用）
手順:
Composition APIを使用するために、@vue/composition-apiをインストールします。
フロントエンドでVue.jsを設定し、Composition APIを使ってデータを取得・表示します。
コマンド:
```bash
コードをコピーする
# webpackerのセットアップ（既に実行済みであれば不要）
bundle exec rails webpacker:install
bundle exec rails webpacker:install:vue

# Vue Composition APIのインストール
yarn add @vue/composition-api

# Vueのコンポーネント作成
mkdir -p app/javascript/components
touch app/javascript/components/GssTable.vue

```
main.js の設定:
```javascript
コードをコピーする
// app/javascript/packs/application.js または main.js

import Vue from 'vue'
import VueCompositionApi from '@vue/composition-api'

Vue.use(VueCompositionApi)

// 既存のコード...
GssTable.vue の例（Composition API使用）:
```

```vue
コードをコピーする
<template>
  <v-data-table :items="gssData" :headers="headers"></v-data-table>
</template>

<script>
import { ref, onMounted } from '@vue/composition-api';
import axios from 'axios';

export default {
  setup() {
    const gssData = ref([]);
    const headers = ref([
      { text: 'Name', value: 'name' },
      { text: 'Value', value: 'value' }
    ]);

    onMounted(() => {
      axios.get('/api/gss_data')
        .then(response => {
          gssData.value = response.data;
        });
    });

    return {
      gssData,
      headers
    };
  }
};
</script>
```

5. データの四則演算とグラフ表示（Composition API対応）
手順:
フロントエンドで四則演算の機能を実装します。
データをグラフ表示するためにChart.jsなどのライブラリを導入します。
Composition APIを使用してロジックを実装します。
コマンド:
```bash
コードをコピーする
# Chart.jsのインストール
yarn add chart.js
```
グラフ表示の例（Composition API使用）:
```vue
コードをコピーする
<template>
  <div>
    <canvas ref="chartCanvas"></canvas>
  </div>
</template>

<script>
import { ref, onMounted } from '@vue/composition-api';
import Chart from 'chart.js';

export default {
  setup() {
    const chartCanvas = ref(null);

    onMounted(() => {
      const ctx = chartCanvas.value.getContext('2d');
      new Chart(ctx, {
        type: 'line',
        data: {
          labels: ['January', 'February', 'March', 'April'],
          datasets: [{
            label: 'GSS Data',
            data: [10, 20, 30, 40],
          }]
        }
      });
    });

    return {
      chartCanvas
    };
  }
};
</script>
```
## 6. Rspecテスト
手順:
モデルやコントローラーのテストケースをRSpecで作成します。
コマンド:
```bash
コードをコピーする
# RSpecのインストール
bundle add rspec-rails
rails generate rspec:install

# テストの実行
bundle exec rspec
```
## 7. タスクテーブル/モデル定義

### 1. タスク定義
```ruby
rails generate migration CreateGssSyncTasks name:string status:integer scheduled_at:datetime completed_at:datetime gss_url:string tab_name:string
```

```ruby
class CreateGssSyncTasks < ActiveRecord::Migration[6.0]
  def change
    create_table :gss_sync_tasks do |t|
      t.string :name, null: false
      t.integer :status, default: 0, null: false
      t.datetime :scheduled_at
      t.datetime :completed_at
      t.string :gss_url, null: false
      t.string :tab_name, null: false

      t.timestamps
    end
  end
end
```

```ruby
rails db:migrate
```

### 2. モデル定義
```ruby
class GssSyncTask < ApplicationRecord
  enum status: { pending: 0, in_progress: 1, completed: 2, failed: 3 }

  validates :name, presence: true
  validates :status, inclusion: { in: statuses.keys }
  validates :gss_url, presence: true
  validates :tab_name, presence: true
end
```

### 3. 同期サービス生成

```ruby
class GssSyncTasksController < ApplicationController
  def create
    task = GssSyncTask.create!(
      name: "スプレッドシート同期",
      status: :pending,
      gss_url: "https://docs.google.com/spreadsheets/d/xxxxxxx", # 実際の URL を設定
      tab_name: "Sheet1" # 実際のタブ名を設定
    )
    
    # ジョブや同期処理を非同期に実行
    SpreadsheetSyncJob.perform_async(task.id)
    
    redirect_to tasks_path, notice: 'タスクが作成されました。'
  end
end
```

```ruby
class SpreadsheetSyncService
  def self.sync_spreadsheet(task)
    # スプレッドシート URL とタブ名を使用して同期処理を実行
    gss_url = task.gss_url
    tab_name = task.tab_name

    # Google Sheets API などを使って同期処理を実行
    result = ::SpreadsheetsImport::UpdateService.new(gss_url, tab_name).execute

    if result.success?
      task.update!(status: 'completed', completed_at: Time.current)
    else
      task.update!(status: 'failed')
    end
  end
end
```

## 8. デーモンの定義

### 1. sidekickサーバーの定義

docker-compose.yml 
```ruby　
・・・
 sidekiq:
    build:
    command: bundle exec sidekiq
    volumes:
      - ".:/app"
    depends_on:
      - db
    environment:
      - RAILS_ENV=development
    networks:
      - app_network
・・・
```

config/sidekiq.yml
```ruby
:concurrency: 5
:queues:
  - default
  - mailers
```

### 2. job定義

```ruby
class GssSyncJob
  include Sidekiq::Worker

  def perform(task_id)
    task = GssSyncTask.find(task_id)
    # GSSの更新処理を呼び出す
    SpreadsheetSyncService.sync_spreadsheet(task)
  end
end
```







