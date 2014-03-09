#!/bin/sh

curl -X POST -H "Content-type: application/json" localhost:3000/users/1/tasks/schedule.json -d @schedule_task.json | json_xs | vim -
