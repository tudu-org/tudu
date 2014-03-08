#!/bin/sh

curl -X POST -H "Content-type: application/json" -d @log_in.json localhost:3000/login.json | json_xs | vim -
