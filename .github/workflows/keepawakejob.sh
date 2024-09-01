#!/bin/bash

proxies=(
    "38.154.227.167:5868"
    "45.127.248.127:5128"
    "64.64.118.149:6732"
    "167.160.180.203:6754"
    "166.88.58.10:5735"
    "173.0.9.70:5653"
    "45.151.162.198:6600"
    "204.44.69.89:6342"
    "173.0.9.209:5792"
    "206.41.172.74:6634"
)

projects=(
    "https://blog-latest.onrender.com/login"
    "https://noteapp001.onrender.com/"
    "https://satiscraper.onrender.com/"
    "https://smartpdf.onrender.com"
)

echo "Projects:"
for project in "${projects[@]}"; do
    echo "$project"
done

timeout=60      
interval=5     
proxy_count=${#proxies[@]} 

overall_success=false

check_project_with_proxy() {
    local project=$1
    local proxy=$2
    local start_time=$(date +%s)
    local end_time=$((start_time + timeout))

    echo "Trying proxy: $proxy for $project"

    while [ $(date +%s) -lt $end_time ]; do
        response=$(curl -s -o /dev/null -w "%{http_code}" -x "$proxy" -m 10 --connect-timeout 5 "$project")

        if [ "$response" -eq 200 ]; then
            echo "Success with proxy: $proxy"
            return 0
        else
            echo "Failed with proxy: $proxy, HTTP status: $response"
        fi

        echo "Retrying in $interval seconds..."
        sleep $interval
    done

    echo "Timed out waiting for a successful response with proxy: $proxy"
    return 1
}

for project in "${projects[@]}"; do
    echo "Checking $project"
    
    project_success=false

    for ((i = 0; i < proxy_count; i++)); do
        proxy=${proxies[$RANDOM % proxy_count]}
        
        echo "Selected proxy: $proxy"
        
        if check_project_with_proxy "$project" "$proxy"; then
            project_success=true
            break  
        fi
    done

    if $project_success; then
        overall_success=true
    else
        echo "All proxies failed for project: $project"
    fi
done

if ! $overall_success; then
    echo "All projects failed with all proxies."
    exit 1
else
    echo "At least one project was successfully accessed."
    exit 0
fi
