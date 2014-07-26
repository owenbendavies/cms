Deployment Cloud Storage
========================

Cloud Files
-----------

Rackspace cloud files is used to store and serve site images and stylesheets in
production. Follow these steps to set up:

* First signup up for a [Rackspace](http://www.rackspace.com/) account.
* Update `RACKSPACE_USERNAME` and `RACKSPACE_API_KEY` in
  `config/application.yml` fore Heroku, or
  `config/deploy/production.application.yml` for server.
* Create a container called `environment_cms_host_name` for each site you create
  in the next steps and make a note of it's url, e.g. for a site with the host
  www.example.com in development mode, create a container called
  `development_cms_www_example_com`.
* When adding sites, set the `asset_host`, e.g.
  `site.asset_host = 'http://b80c6e.rackcdn.com'`

Amazon CloudFront
-----------------

It is recommended to set up a Amazon CloudFront distribution to serve the Rails
assets for your site. Once set up, add the distribution url to `ASSET_HOST` in
`config/application.yml` for Heroku or
`config/deploy/production.application.yml` for server.

