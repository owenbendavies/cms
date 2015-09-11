FROM ubuntu:trusty
MAINTAINER Owen Ben Davies

# Install puppet
COPY puppet /opt/puppet
RUN /opt/puppet/bin/setup_server

# Copy app
COPY . /home/rails/cms
RUN chown --recursive rails:rails /home/rails/cms

# Change user
USER rails
WORKDIR /home/rails/cms

# Set environment
ENV PATH /usr/local/rbenv/shims:/usr/local/rbenv/bin:$PATH
ENV RACK_ENV production

# Install app
RUN ./bin/bundle install --without assets development test --deployment --quiet

# Set up networking
EXPOSE 3000

# Run app
CMD ./bin/puma --config config/puma.rb
