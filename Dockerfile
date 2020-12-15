FROM ruby:2.7.1

ENV RAILS_ENV=production
ENV RAILS_SERVE_STATIC_FILES=true

WORKDIR /opt/siteinspector

COPY ./Gemfile ./Gemfile.lock ./

RUN bundle config set with 'production' && bundle install && gem install foreman

COPY . ./

CMD ["/bin/bash"]
