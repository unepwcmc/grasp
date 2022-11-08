FROM ruby:2.3.1

RUN mkdir /grasp
WORKDIR /grasp

RUN apt-get update && apt-get install -y \
  curl gnupg \
  build-essential \
  libpq-dev &&\
  curl -sL https://deb.nodesource.com/setup_16.x | bash - && \
  apt-get update && apt-get install -y nodejs npm

ENV BUNDLER_VERSION=1.17.3

RUN gem install bundler -v ${BUNDLER_VERSION} --no-document

ADD Gemfile /grasp/Gemfile
ADD Gemfile.lock /grasp/Gemfile.lock
RUN bundle install

COPY package.json /grasp/package.json
RUN npm install

ADD . /grasp
