const { environment } = require('@rails/webpacker')
const { VueLoaderPlugin } = require('vue-loader')
const MiniCssExtractPlugin = require('mini-css-extract-plugin')
const pkg = require('../../package.json')
const webpack = require('webpack')

environment.loaders.append('vue',
  {
    test: /\.vue$/,
    use: [{
      loader: 'vue-loader'
    }]
  }
)

environment.plugins.append('VueLoaderPlugin', new VueLoaderPlugin())

environment.plugins.append('DefinePlugin', new webpack.DefinePlugin({
  'process.env.VERSION': JSON.stringify(pkg.version)
}))

module.exports = environment
