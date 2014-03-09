#!/bin/sh

curl -o /dev/null -w "Status code: %{http_code}" -X PATCH -H "Content-type: application/json" -d @update_event.json localhost:3000/users/1/events/1.json 2>/dev/null
echo
