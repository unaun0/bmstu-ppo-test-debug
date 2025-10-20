#!/bin/bash
set -e

export PGPASSWORD="password"
psql -h localhost -U postgres -d testdb -p 5433 -f Shared/db/clean-scripts/clean_db.sql
