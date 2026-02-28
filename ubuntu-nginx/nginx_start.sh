#!/bin/bash

# Start NGINX in the foreground with debug messages enabled
nginx

# Execute the command provided to the container (which is /bin/bash 
# by default due to the CMD)
exec "$@"

