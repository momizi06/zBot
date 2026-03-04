# Node.js の安定版を使用
FROM node:lts-bullseye

# 作業ディレクトリを作成
WORKDIR /app
RUN mkdir -p /app/guild_configs /app/guild_dictionaries

# 依存関係のインストールに必要なファイルをコピー
COPY package.json ./

# 依存関係をインストール
# Python や build-essential は node:lts-bullseye に含まれているため、
# @discordjs/opus などのネイティブモジュールのビルドも通常は問題なく行えます。
RUN npm install

# 接続確認用ツール (curl) のインストール
RUN apt-get update && apt-get install -y curl && rm -rf /var/lib/apt/lists/*

# アプリケーションのソースコードをコピー
COPY . .

# VOICEVOX (http://voicevox:50021) の起動を待機してからアプリケーションを開始
CMD sh -c 'echo "Waiting for VOICEVOX..." && \
           until curl -s http://voicevox:50021/version > /dev/null; do \
             sleep 3; \
           done && \
           echo "VOICEVOX is ready! Starting zBot..." && \
           node index.js'
