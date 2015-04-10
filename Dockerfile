FROM ubuntu:trusty
MAINTAINER Owen Ben Davies

# Install puppet
COPY puppet /opt/puppet
WORKDIR /opt/puppet

RUN apt-get update && \
  apt-get install --yes build-essential ruby-dev wget && \
  gem install puppet librarian-puppet --no-rdoc --no-ri && \
  librarian-puppet install && \
  puppet apply manifests/production.pp --confdir=. && \
  apt-get purge --yes --auto-remove build-essential ruby-dev

# Copy app
COPY . /home/rails/cms
RUN chown --recursive rails:rails /home/rails/cms

# Change user
USER rails
WORKDIR /home/rails/cms

# Set environment
ENV NEW_RELIC_LOG stdout
ENV PATH /usr/local/rbenv/shims:/usr/local/rbenv/bin:$PATH
ENV RAILS_ENV production
ENV WORKER_PROCESSES 3

# Install app
RUN cp -f config/secrets.yml.production config/secrets.yml && \
  ./bin/bundle install --without development test --deployment --quiet

# Set up networking
EXPOSE 3000

# Run app
CMD ./bin/server
