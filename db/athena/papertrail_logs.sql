CREATE EXTERNAL TABLE IF NOT EXISTS papertrail_logs (
 id BIGINT,
 generated_at STRING,
 received_at STRING,
 source_id BIGINT,
 source_name STRING,
 source_ip STRING,
 facility_name STRING,
 severity_name STRING,
 program STRING,
 message STRING
)
PARTITIONED BY (dt string)
ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.lazy.LazySimpleSerDe'
WITH SERDEPROPERTIES (
 'serialization.format' = '	',
 'field.delim' = '	'
) LOCATION 's3://${LOGS_BUCKET}/papertrail/'
