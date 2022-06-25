# azure-dns-updater

Small scripts that lets you use Azure DNS as a Dynamic DNS service to make your home reachable via your own domain.

## Prerequisites

- Azure CLI
- dig (bind-tools)

## Configuration

The script is configured via environment variables. 

|Variable|Default value|Description|
|---|---|---|
|`AZURE_CLIENT_ID`||Client Id of a service principal that is allowed to update DNS records|
|`AZURE_CLIENT_SECRET`||Client secret of a service principal that is allowed to update DNS records|
|`AZURE_TENANT_ID`||Tenant Id of a service principal that is allowed to update DNS records|
|`RECORDS`||A list of DNS records to update. The format must be `{RESOURCE_GROUP}/{ZONE}/{RECORD}` e.g. `myrg/mydomain/home mrrg/myotherdomain/foo`|
|`INTERVALL`|`5m`|The interval to check if the ip address has changed|
|`DEBUG`|`false`|If set to `true` the script will log more information|

## Usage

Just run the script.

```bash
./azure-dns-updater.sh
```

The script will run until terminated and will check for ip address changes based on the interval.

The script uses the `dig` command to query the current ip address from opendns.

## docker

The dockerfile is intended to run on ARM based devices (32 bit) e.g. Raspberry Pis