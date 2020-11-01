#!/bin/bash
set -e

psql -v ON_ERROR_STOP=1 --username netflow -d netflow -f /home/2_createtables.sql
