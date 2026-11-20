#!/bin/sh
set -eu

DATABASE_URL="$(cat /run/secrets/database_url)"
SESSION_SECRET="$(cat /run/secrets/session_secret)"
TWO_FACTOR_ENCRYPTION_KEY="$(cat /run/secrets/two_factor_encryption_key)"
PRECIOS_REFERENCIA_JWT_TOKEN="$(cat /run/secrets/precios_referencia_jwt_token)"

export DATABASE_URL
export SESSION_SECRET
export TWO_FACTOR_ENCRYPTION_KEY
export PRECIOS_REFERENCIA_JWT_TOKEN

exec "$@"