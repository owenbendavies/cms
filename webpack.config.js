const path = require('path');

const webpack = require('webpack');

module.exports = {
  devtool: 'source-map',
  entry: {
    admin: './app/javascript/admin.jsx',
    application: './app/javascript/application.js',
  },
  mode: 'production',
  module: {
    rules: [
      {
        exclude: /node_modules/,
        test: /\.m?jsx?$/,
        use: {
          loader: 'babel-loader',
          options: {
            presets: ['@babel/preset-env'],
          },
        },
      },
    ],
  },
  output: {
    filename: '[name].js',
    path: path.resolve(__dirname, 'app/assets/builds'),
    sourceMapFilename: '[name].js.map',
  },
  plugins: [
    new webpack.optimize.LimitChunkCountPlugin({
      maxChunks: 1,
    }),
  ],
  resolve: {
    extensions: ['.js', '.jsx'],
  },
};
