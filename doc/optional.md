# Optional Steps

## Amazon Web Servcies

* My Account
  * Alternate Contacts
* Billing & Cost Management
  * Preferences > Receive PDF Invoice By Email
* Security credentials
  * Enable multi factor authentication
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
  * Preferences > Email notifications
* SES

## Heroku Add-ons

* loader.io

## Services

* CloudFlare
