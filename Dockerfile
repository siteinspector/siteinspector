FROM ruby:3.1.0 AS webpacker

ENV RAILS_ENV=production

WORKDIR /app

RUN curl -sL https://deb.nodesource.com/setup_16.x | sh - && \
    apt-get install -yq nodejs python && \
    npm install -g yarn && \
    gem install shakapacker && \
    rm -rf /var/lib/apt/lists/*

COPY ./package.json ./yarn.lock ./

RUN yarn install

COPY ./bin/webpacker ./bin/webpacker
COPY ./config/webpack ./config/webpack
COPY ./config/webpacker.yml ./config/webpacker.yml
COPY ./postcss.config.js ./babel.config.js ./
COPY ./app/javascript ./app/javascript

RUN echo "gem 'shakapacker'" > Gemfile && ./bin/webpacker

FROM ruby:3.1.0 as app

ENV RAILS_ENV=production
ENV TZ=UTC

WORKDIR /opt/siteinspector

COPY ./Gemfile ./Gemfile.lock ./

RUN bundle config set with 'production' && \
    bundle install && \
    gem install foreman

COPY . ./

COPY --from=webpacker /app/public/packs ./public/packs

CMD ["foreman", "start"]
