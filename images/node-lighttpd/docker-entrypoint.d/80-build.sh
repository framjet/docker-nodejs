#!/bin/sh

set -e

ME=$(basename "$0")

entrypoint_log() {
    if [ -z "${NODE_ENTRYPOINT_QUIET_LOGS:-}" ]; then
        echo "$@"
    fi
}

# Function to check and execute dockerBuild.sh if it exists
process_docker_build() {
    if [ -f "/app/dockerBuild.sh" ]; then
        entrypoint_log "$ME: Found /app/dockerBuild.sh - executing..."

        # Make sure the script is executable
        chmod +x /app/dockerBuild.sh

        # Execute the script
        /app/dockerBuild.sh

        entrypoint_log "$ME: Finished executing /app/dockerBuild.sh"
    else
        entrypoint_log "$ME: /app/dockerBuild.sh not found - skipping execution"
    fi
}

# Execute the function
process_docker_build

exit 0
