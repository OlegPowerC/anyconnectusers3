#!/bin/bash
docker run -v $(pwd)/data/db:/var/lib/postgresql/data -v $(pwd)/init:/docker-entrypoint-initdb.d:ro -v $(pwd)/sqlfiles:/home:ro postgres
