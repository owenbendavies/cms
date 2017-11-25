CREATE EXTERNAL TABLE IF NOT EXISTS cloudfront_logs (
  date DATE,
  time STRING,
  location STRING,
  response_bytes BIGINT,
  ip STRING,
  method STRING,
  host STRING,
  uri STRING,
  status INT,
  referrer STRING,
  user_agent STRING,
  query_string STRING,
  cookie STRING,
  edge_result STRING,
  id STRING,
  host_header STRING,
  protocol STRING,
  request_bytes BIGINT,
  time_taken FLOAT,
  x_forwarded_for STRING,
  ssl_protocol STRING,
  ssl_cipher STRING,
  response_result STRING,
  protocol_version STRING
)
ROW FORMAT DELIMITED FIELDS TERMINATED BY '\t'
LOCATION 's3://${LOGS_BUCKET}/AWSLogs/${ACCOUNT}/cloudfront/${APP_NAME}/'
