job_type :rake, "cd :path && :environment_variable=:environment ./bin/rake :task --silent :output"

every 1.hour, roles: [:db]  do
  rake 'db:backup'
end
