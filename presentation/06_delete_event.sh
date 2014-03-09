#!/bin/sh

curl -o /dev/null -w "Status code: %{http_code}" -X DELETE -H "Content-type: application/json" localhost:3000/users/1/events/1.json?auth_token=add8ee8b8fa15f049f1c71b75e5d2bd2 2>/dev/null
echo
