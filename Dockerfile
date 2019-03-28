FROM ruby:2.6.2

ARG ENVIRONMENT
ARG RAILS_MASTER_KEY

ENV RAILS_MASTER_KEY $RAILS_MASTER_KEY
ENV RAILS_ENV $ENVIRONMENT
ENV RAILS_SERVE_STATIC_FILES true

RUN apt-get update -qq && apt-get install -y \
build-essential \
nodejs

RUN mkdir /app

WORKDIR /app

COPY Gemfile /app/Gemfile
COPY Gemfile.lock /app/Gemfile.lock

RUN gem install bundler
RUN bundle install

COPY . /app
