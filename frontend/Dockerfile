FROM node:20-alpine

WORKDIR /app

# パッケージファイルをコピー
COPY package*.json ./

# 依存関係をインストール
RUN npm install

# アプリケーションコードをコピー
COPY . .

# 権限を修正 (nodeユーザー: UID 1000)
RUN chown -R node:node /app

EXPOSE 3000

CMD ["npm", "run", "dev"]
