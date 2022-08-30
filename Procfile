release: RAILS_ENV=$RAILS_ENV bundle exec rake db:migrate
web: bin/rails server -p ${PORT:-5000} -e $RAILS_ENV
worker: bundle exec sidekiq -q remarks -q searchkick -q photos
