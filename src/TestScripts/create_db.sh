#!/bin/sh
set -e

export PGPASSWORD="password"
psql -h localhost -U postgres -d testdb -p 5433 -f Shared/db/init-scripts/create_db.sql
