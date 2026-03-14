#!/bin/bash

# Start NGINX in the foreground with debug messages enabled
# <commented> nginx 
echo "Starting nginx ..."

# Execute the command provided to the container (which is /bin/bash 
# by default due to the CMD)
# <commented> exec "$@"

# command for docker compose
exec nginx -g "daemon off;"

