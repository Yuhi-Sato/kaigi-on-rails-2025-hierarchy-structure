FROM ruby:3.4.3

WORKDIR /usr/src/app

RUN apt-get update -qq && \
    apt-get install -y --no-install-recommends \
    build-essential \
    postgresql-client \
    && rm -rf /var/lib/apt/lists/*

COPY Gemfile Gemfile.lock .ruby-version ./
RUN bundle install

COPY . .

CMD ["tail", "-f", "/dev/null"]
