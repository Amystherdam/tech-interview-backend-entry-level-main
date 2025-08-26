set -e

DB_NAME=${POSTGRES_DB:-store_development}
TEST_DB_NAME=${POSTGRES_TEST_DB:-store_test}
RAILS_ENV=${RAILS_ENV:-development}

create_db_if_not_exists() {
  local DB_TO_CHECK=$1
  local ENV_TO_USE=$2

  if RAILS_ENV=$ENV_TO_USE bundle exec rails db:environment:set >/dev/null 2>&1; then
    echo "Database ${DB_TO_CHECK} already exists."
  else
    echo "Database ${DB_TO_CHECK} not found. Creating..."
    RAILS_ENV=$ENV_TO_USE bundle exec rails db:create
  fi
}

if [ "$RAILS_ENV" == "development" ]; then
  create_db_if_not_exists "$DB_NAME" development
  bundle exec rails db:migrate
elif [ "$RAILS_ENV" == "test" ]; then
  create_db_if_not_exists "$TEST_DB_NAME" test
  bundle exec rails db:migrate
else
  echo "Environment $RAILS_ENV is not supported in this script."
fi

exec "$@"
