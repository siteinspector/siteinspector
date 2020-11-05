const { environment } = require('@rails/webpacker')
const { VueLoaderPlugin } = require('vue-loader');
const MiniCssExtractPlugin = require('mini-css-extract-plugin');

environment.loaders.append('less',
  {
    test: /\.less$/,
    use: [
      { loader: MiniCssExtractPlugin.loader },
      { loader: 'css-loader' },
      { loader: 'less-loader', options: { lessOptions: { javascriptEnabled: true } } }
    ]
  }
)

environment.loaders.append('vue',
  {
    test: /\.vue$/,
    use: [{
      loader: 'vue-loader'
    }]
  }
)

environment.plugins.append('VueLoaderPlugin', new VueLoaderPlugin())

module.exports = environment
