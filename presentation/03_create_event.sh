#!/bin/sh

curl -X POST -H "Content-type: application/json" localhost:3000/users/1/events.json -d @new_event.json | json_xs | vim -
