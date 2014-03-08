#!/bin/sh

curl -X POST -H "Content-type: application/json" localhost:3000/users.json -d @new_user.json | json_xs | vim -
