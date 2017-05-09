web: ./bin/puma
worker: ./bin/delayed_job_worker_pool config/delayed_job_worker_pool.rb
release: ./bin/rails db:migrate db:seed
