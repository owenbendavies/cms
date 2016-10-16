# Optional Steps

## Amazon Web Servcies

* My Account
  * Alternate Contacts
* Billing & Cost Management
  * Preferences > Receive PDF Invoice By Email
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
* CloudWatch (notifications)
  * Add Alarms (e.g. Billing, RDS)
* CloudTrail (account logging)
* Config (account versioning)
* Trusted Advisor (security suggestions)
  * Fix any issues
  * Preferences > Email notifications
* Identity and Access Management (user accounts)
  * Fix any bad security status
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
* tinfoilsecurity (security scanner)

## Services

* CloudFlare (firewall)
  * Enable Full SSL
* DMARC Analyzer (email checker)
  * Add DNS record for each domain with email
  * Send reports
* Google Analytics (visitor statistics)
  * Property
    * Settings
      * Enable Demographics
      * Use enhanced link attribution
    * Tracking Info
      * Enable User-ID
* Google Login
  1. Go to https://console.developers.google.com
  1. Go to 'Credentials'
  1. Create a new project
  1. Go to 'OAuth consent screen'
  1. Provide an 'email address' and 'product name'
  1. Create some 'OAuth Credentials'
    1. Select 'Web application'
    1. Set a name
    1. Set 'Authorized redirect URIs', e.g. https://www.example.com/user/auth/google/callback
  1. Enable the 'Contacts API' and 'Google+ API'
