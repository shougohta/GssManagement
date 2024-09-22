const { watch } = require('fs')
const path = require('path')
const VueLoaderPlugin = require('vue-loader/lib/plugin')

module.exports = {

    entry: './src/main.ts',
    output: {
        path: path.resolve(__dirname, 'public', 'js'),
        filename: 'bundle.js'
    },
    devServer: {
        static: path.resolve(__dirname, 'public')  // Webpack 5ではstaticを使用
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
                loader: 'babel-loader'
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
    ]
}
