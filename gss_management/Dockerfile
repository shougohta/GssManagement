FROM ruby:2.7.3

# Node.jsのインストール
RUN curl -fsSL https://deb.nodesource.com/setup_lts.x | bash - && \
    apt-get install -y nodejs

# YarnとNode.jsの特定バージョンをインストール
RUN npm install --global yarn && npm install -g n && n 16.15.1

# Vimのインストール
RUN apt-get update && apt-get install -y vim

# 作業ディレクトリの設定
WORKDIR /gss_management

# GemfileとGemfile.lockのコピー
COPY Gemfile Gemfile.lock /gss_management/

# Rubyプラットフォームの強制設定とbundlerのインストール
RUN bundle config set force_ruby_platform true && \
    bundle install
