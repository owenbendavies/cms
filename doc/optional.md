# Optional Steps

The following optional steps can be followed to add extra services.

## Amazon Web Servcies

* [AWS Account](aws_account.md) settings
* S3 (for storing files)
  * Enable versioning
  * Add lifecycle to delete old versions (if concerned about cost or sensitivity)
  * Enable logging
* CloudFront (for caching files)
  * Distribution for caching S3 bucket
  * Distribution for caching application assets
  * Enable logging
* RDS (Database alternative to heroku-postgresql)
  * Verify SSL in URL `postgresql://username:password@url:5432/database?sslmode=verify-full&sslrootcert=db/amazon-rds-ca-cert.pem`
  * Parameter Groups
    * rds.force_ssl = 1
* SES (Email alternative to sendgrid)
  * Add [policy](iam_ses_policy.json) to IAM user
  * Use DKIM

## Heroku Add-ons

* loader.io (load testing)
  * Schedule regular check
* newrelic (system metrics)
  * Add Synthetics
  * Add Alerts
* papertrail (logging)
  * Archive to S3
  * Heroku alerts
  * Profile > Time Zone
* rollbar (error notifications)
* scheduler (job runner)
  * Add `./bin/rails runner 'DailyJob.perform_now'`

## Services

* CloudFlare (firewall)
  * Enable Full SSL
* DMARC Analyzer (email checker)
  * Add DNS record for each domain with email
  * Send reports
* [Google Analytics](google_analytics.md) (visitor statistics)
* [Google Login](google_login.md)
