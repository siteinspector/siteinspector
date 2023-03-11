FROM ruby:3.1.0-alpine as webpacker

ENV RAILS_ENV=production

WORKDIR /app

RUN apk add --no-cache nodejs yarn git build-base python3 && \
    gem install shakapacker

COPY ./package.json ./yarn.lock ./

RUN yarn install

COPY ./bin/webpacker ./bin/webpacker
COPY ./config/webpack ./config/webpack
COPY ./config/webpacker.yml ./config/webpacker.yml
COPY ./postcss.config.js ./babel.config.js ./
COPY ./app/javascript ./app/javascript

RUN echo "gem 'shakapacker'" > Gemfile && ./bin/webpacker

FROM ruby:3.1.0-alpine as app

ENV RAILS_ENV=production
ENV TZ=UTC
ENV BUNDLE_WITHOUT="development:test"

WORKDIR /opt/siteinspector

RUN apk add --no-cache libpq-dev build-base libcurl gcompat bash

COPY ./Gemfile ./Gemfile.lock ./

RUN bundle install && rm -rf ~/.bundle && gem install foreman

COPY . ./

COPY --from=webpacker /app/public/packs ./public/packs

RUN bundle exec bootsnap precompile --gemfile app/ lib/

CMD ["foreman", "start"]
