#!/bin/bash
set -e

psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" <<-EOSQL
    CREATE USER netflow WITH PASSWORD 'netflow';
    CREATE DATABASE netflow;
    GRANT ALL PRIVILEGES ON DATABASE netflow TO netflow;
EOSQL

