#!/bin/sh

curl -X GET -H "Content-type: application/json" localhost:3000/users/1/events.json?auth_token=add8ee8b8fa15f049f1c71b75e5d2bd2 | json_xs | vim -
