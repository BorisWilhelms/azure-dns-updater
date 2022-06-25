#! /bin/bash

INTERVAL=${INTERVAL:-5m}
DEBUG=${DEBUG:-false}

log() {
    echo "$(date "+%Y-%m-%d %H:%M:%S") $1: $2"
}

error() {
    log "ERROR" "$1"
}

debug() {
    if [ "$DEBUG" = "true" ]; then
        log "DEBUG" "$1"
    fi
}

info() {
    log "INFO" "$1"
}

if [ -z "$AZURE_CLIENT_ID" ] || [ -z "$AZURE_CLIENT_SECRET" ] || [ -z "$AZURE_TENANT_ID" ]; then
    error "AZURE_CLIENT_ID, AZURE_CLIENT_SECRET and AZURE_TENANT_ID must be set"
    exit 1
fi


if [ -z "$RECORDS" ]; then
    error "No records (RECORDS)) are defined."
    exit 1
fi

info "Using interval of $INTERVAL"

az config set core.output=none

previp=
while :
do
    debug "Running check"
    
    ip=$(dig @resolver4.opendns.com myip.opendns.com +short)
    debug "Got IP $ip"
    debug "Previous IP was $previp"

    if [ "$previp" != "$ip" ] 
    then
        info "IP changed to $ip, updating dns records"

        debug "Logging in to Azure"
        az login --service-principal \
            -u "$AZURE_CLIENT_ID" \
            -p "$AZURE_CLIENT_SECRET" \
            --tenant "$AZURE_TENANT_ID"
        
        for r in $RECORDS;
        do
            IFS='/' read -ra record_parts <<< "$r"
            rg=${record_parts[0]}
            zone=${record_parts[1]}   
            record=${record_parts[2]}

            info "Updating $record in $zone"
            az network dns record-set a update \
                --resource-group "$rg" \
                --zone-name "$zone" \
                --name "$record" \
                --set aRecords[0].ipv4Address="$ip"
        done
        
        debug "Logging out from Azure"
        az logout

        info "Update done"
    fi
    
    previp="$ip"
    
    sleep "$INTERVAL"
done


