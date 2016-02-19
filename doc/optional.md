# Optional Steps

## Amazon Web Servcies

* My Account
  * Alternate Contacts
* Billing & Cost Management
  * Preferences > Receive PDF Invoice By Email
* S3
  * Enable versioning
  * Add lifecycle to delete old versions
  * Enable logging
* CloudFront
  * Distribution for caching S3 bucket
  * Distribution for caching application assets
  * Enable logging
* RDS
  * Verify SSL in URL `postgresql://username:password@url:5432/database?sslmode=verify-full&sslrootcert=config/amazon-rds-ca-cert.pem`
* CloudWatch
  * Billing > Total Estimated Charge
* CloudTrail
* Config
* Trusted Advisor
  * Fix any issues
  * Preferences > Email notifications
* Identity and Access Management
  * Fix any bad security status
* SES
  * Add [policy](iam_ses_policy.json) to IAM user
  * Use DKIM

## Heroku Add-ons

* loader.io
  * Schedule regular check
* newrelic
  * Add Synthetics
  * Add Alerts
* papertrail
  * Archive to S3
  * Heroku alerts
  * Profile > Time Zone
* rollbar
* scheduler
  * Add `./bin/rake cms:validate_data` daily
* tinfoilsecurity

## Services

* CloudFlare
  * Enable Full SSL
* DMARC Analyzer
  * Add DNS record for each domain with email
  * Send reports
* Google Analytics
  * Property
    * Settings
      * Enable Demographics
      * Use enhanced link attribution
    * Tracking Info
      * Enable User-ID
