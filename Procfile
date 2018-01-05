web: ./bin/puma
worker: QUIET=true ./bin/rails jobs:work
release: ./bin/rails db:migrate db:seed
