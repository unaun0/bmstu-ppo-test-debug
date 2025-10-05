#!/bin/bash
set -e

PGPASSWORD="password" psql -h localhost -U postgres -d testdb -p 5433 -f Shared/db/init-scripts/create_db.sql
<<<<<<< HEAD

=======
>>>>>>> 8535539 (Update create_db.sh)
