FROM daocloud.io/ruby:2.3.1

ADD sources.list /etc/apt/sources.list
RUN apt-get update && apt-get install -y --force-yes build-essential libssl-dev libpq-dev libxml2-dev libxslt1-dev nodejs git imagemagick libbz2-dev libjpeg-dev libevent-dev libmagickcore-dev libffi-dev libglib2.0-dev zlib1g-dev libyaml-dev --no-install-recommends && rm -rf /var/lib/apt/lists/*

ENV APP_HOME /app
RUN mkdir -p $APP_HOME
WORKDIR $APP_HOME
COPY . $APP_HOME

ENV RAILS_ENV production
ENV SECRET_KEY_BASE 82404df81bcad17fdb571a40fecd33d974e85327d843ab9323c234d63801c36c9dfb07cc4e84f9eef8c3ee7de5cd64e9298f2a6b2b723f1f8b77ca66a0b0cee7

RUN bundle install --local

EXPOSE 3000

CMD ["bundle", "exec", "puma", "-C", "config/puma.rb"]
