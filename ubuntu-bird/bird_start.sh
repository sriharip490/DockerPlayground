#!/bin/bash

# Start BIRD in the foreground with debug messages enabled
# The -f flag runs BIRD in the foreground
# The -d flag enables debug messages to stderr
# The -c flag specifies the configuration file path
bird -f -c /etc/bird/bird.conf &

# Execute the command provided to the container (which is /bin/bash 
# by default due to the CMD)
exec "$@"
