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
3. GSSのデータを変換できる
    1. 四則演算ができる
4. GSSのデータの表示方法を変換できる
    1. グラフ表示できる
    2. etc.

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
