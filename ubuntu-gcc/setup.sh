#!/bin/bash
set -e

# Run the setup script/logic here
echo "Running setup steps..."
/app/data/setup_script.sh 

# Then, execute the main command provided via CMD or docker run arguments
exec "$@" 

