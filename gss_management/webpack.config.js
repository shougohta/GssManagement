const { watch } = require('fs')
const path = require('path')
const VueLoaderPlugin = require('vue-loader/lib/plugin')
const CssMinimizerPlugin = require('css-minimizer-webpack-plugin');

module.exports = {
    mode: 'development',
    entry: './src/main.ts',
    output: {
        path: path.resolve(__dirname, 'public', 'js'),
        filename: 'bundle.js'
    },
    devServer: {
        static: path.resolve(__dirname, 'public'), // 静的ファイルの提供
        hot: true, // ホットリロードを有効にする
        open: true, // ブラウザを自動で開く
        port: 8080, // 使用するポート
        historyApiFallback: true, // SPAの場合、404エラーを回避する
        client: {
            webSocketURL: {
                pathname: '/ws', // WebSocketのパス
                port: 8080, // ポートを指定
            }
        }
    },
    watchOptions: {
        poll: true
    },
    watch: true,
    module: {
        rules: [
            {
                test: /\.vue$/,
                loader: 'vue-loader'
            },
            {
                test: /\.js$/,
                loader: 'babel-loader',
                exclude: /node_modules/,
            },
            {
                test: /\.ts$/,
                use: [{
                    loader: 'ts-loader',
                    options: {
                        appendTsSuffixTo: [/\.vue$/]  // .vueファイルにTSを適用
                    }
                }]
            },
            {
                test: /\.css$/,
                use: ['vue-style-loader', 'css-loader']
            }
        ]
    },
    resolve: {
        extensions: ['.js', '.ts', '.vue', '.json'],
        alias: {
            'vue$': 'vue/dist/vue.esm.js'  // Vue 2向けエイリアス
        }
    },
    plugins: [
        new VueLoaderPlugin(),
    ],
    optimization: {
        minimize: true,
        minimizer: [
            new CssMinimizerPlugin(),
        ],
    }
}
