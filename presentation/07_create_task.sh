#!/bin/sh

curl -X POST -H "Content-type: application/json" localhost:3000/users/1/tasks.json -d @new_task.json | json_xs | vim -
