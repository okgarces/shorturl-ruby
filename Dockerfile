FROM ruby:2.6.3

RUN apt-get update -qq && apt-get install -y build-essential libpq-dev sqlite3 git
RUN gem install rails -v 6.0.0.rc1

RUN mkdir /srv/app
COPY Gemfile Gemfile.lock /srv/app/
RUN gem install bundler -v 1.17.2
RUN gem install foreman -v 0.85.0

WORKDIR /srv/app
RUN bundle install --verbose --jobs 20 --retry 5

COPY . /srv/app

EXPOSE 3000

CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0"]