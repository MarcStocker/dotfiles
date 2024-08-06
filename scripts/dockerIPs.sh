#!/bin/bash

# Check if docker compose is installed
if ! command -v docker &> /dev/null || ! docker compose version &> /dev/null; then
    echo "docker compose could not be found. Please ensure Docker is installed and the compose plugin is available."
    exit 1
fi

# List all running containers using docker compose
containers=$(docker compose ls -q)

# Check if there are any running containers
if [ -z "$containers" ]; then
    echo "No running containers found."
    exit 0
fi

echo "Listing IP addresses of running containers:"

# Initialize an array to store container information
declare -A container_ips

# Loop through each container and get its IP address
for container in $containers; do
    container_name=$(docker inspect --format '{{.Name}}' $container | sed 's/\///')
    container_ip=$(docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' $container 2>/dev/null)

    if [ -z "$container_ip" ]; then
        if docker inspect $container &>/dev/null; then
            container_ip="non-networked"
        else
            container_ip="containered"
        fi
    fi

    container_ips["$container_name"]=$container_ip
done

# Sort and print the container information by IP address
for container_name in "${!container_ips[@]}"; do
    echo "${container_ips[$container_name]} $container_name"
done | sort -V
