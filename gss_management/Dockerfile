FROM ruby:2.7.3
RUN curl -fsSL https://deb.nodesource.com/setup_lts.x | bash - && apt-get install -y nodejs
RUN npm install --global yarn && npm install -g n && n 16.15.1

WORKDIR /gss_management
COPY Gemfile Gemfile.lock /gss_management/
RUN bundle config set force_ruby_platform true
RUN bundle install
