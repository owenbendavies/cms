CREATE EXTERNAL TABLE IF NOT EXISTS s3_logs (
  owner STRING,
  bucket STRING,
  time STRING,
  ip STRING,
  requester STRING,
  id STRING,
  operation STRING,
  key STRING,
  method STRING,
  uri STRING,
  protocol STRING,
  status INT,
  error_code STRING,
  response_bytes BIGINT,
  object_size BIGINT,
  time_taken FLOAT,
  turn_around_time STRING,
  referrer STRING,
  user_agent STRING,
  version_id STRING
)
ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.RegexSerDe'
WITH SERDEPROPERTIES (
 'serialization.format' = '1',
  'input.regex' = '([^ ]*) ([^ ]*) \\[(.*?)\\] ([^ ]*) ([^ ]*) ([^ ]*) ([^ ]*) ([^ ]*) \\\"([^ ]*) ([^ ]*) (- |[^ ]*)\\\" (-|[0-9]*) ([^ ]*) ([^ ]*) ([^ ]*) ([^ ]*) ([^ ]*) \"([^\"]*)\" \"([^\"]*)\" ([^ ]*)$'
)
LOCATION 's3://${LOGS_BUCKET}/AWSLogs/${ACCOUNT}/s3/${APP_NAME}/'
