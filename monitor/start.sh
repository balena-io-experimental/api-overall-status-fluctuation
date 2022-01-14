#!/bin/sh

if [[ -z "${APIKEY}" || -z "${UUID}" ]]; then
    echo 'APIKEY or UUID need to be added to local .env file, exiting...'
    exit 1
fi

get_update_status() {
    curl --silent \
        -H "Authorization: Bearer ${APIKEY}" \
        "https://api.balena-cloud.com/v6/device?\$filter=startswith(uuid,'$UUID')&\$select=overall_status" \
        | jq -r '.d[0].overall_status' \
        | xargs echo
}

main() {
    local POLL_INTERVAL=1
    local update_status=$(get_update_status)

    while true; do
        echo "overall_status: $update_status"
        sleep $POLL_INTERVAL
        update_status=$(get_update_status)
    done
}

main