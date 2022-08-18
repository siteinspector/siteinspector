const { VueLoaderPlugin } = require('vue-loader')
const { DefinePlugin } = require('webpack')

const baseConfig = {
  module: {
    rules: [
      {
        test: /\.vue$/,
        loader: 'vue-loader'
      },
      {
        test: /\.scss$/,
        use: [
          'postcss-loader',
          'sass-loader'
        ]
      }
    ]
  },
  plugins: [
    new DefinePlugin({
      'process.env': {
        VERSION: JSON.stringify(require('./../../package.json').version)
      }
    }),
    new VueLoaderPlugin()
  ],
  optimization: { splitChunks: { chunks: 'all' }, runtimeChunk: 'single' },
  resolve: {
    extensions: ['.vue']
  }
}

const { webpackConfig, merge } = require('shakapacker')

module.exports = merge(baseConfig, webpackConfig)
