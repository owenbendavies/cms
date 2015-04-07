FROM ubuntu:trusty
MAINTAINER Owen Ben Davies

# Set default locale
RUN locale-gen en_US.utf8
RUN update-locale LANG=en_US.UTF-8

# Install puppet
RUN apt-get update && apt-get install -y build-essential ruby-dev wget
RUN gem install puppet librarian-puppet --no-rdoc --no-ri

# Run puppet
COPY puppet /opt/puppet
WORKDIR /opt/puppet
RUN librarian-puppet install
RUN puppet apply manifests/production.pp --confdir=.

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
RUN cp -f config/secrets.yml.production config/secrets.yml
RUN ./bin/bundle install --without development test --deployment --quiet

# Set up networking
EXPOSE 3000

# Run app
CMD ./bin/server
