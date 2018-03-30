#!/bin/bash
export OS_TENANT_NAME="{{KEYSTONE_ADMIN_TENANT}}"
export OS_USERNAME="{{KEYSTONE_ADMIN_USER}}"
export OS_PASSWORD="{{KEYSTONE_ADMIN_PASSWD}}"
export OS_AUTH_URL="{{KEYSTONE_AUTH_URL}}"

keystone user-create --name={{AUTH_NEUTRON_ADMIN_USER}} --pass={{AUTH_NEUTRON_ADMIN_PASS}} --email=neutron@example.com
keystone user-role-add --user={{AUTH_NEUTRON_ADMIN_USER}} --tenant={{AUTH_NEUTRON_ADMIN_TENANT}} --role=admin

function get_id () {
    echo `"$@" | grep ' id ' | awk '{print $4}'`
}
		
NEUTRON_SERVICE=$(get_id \
keystone service-create --name=neutron \
                        --type=network \
                        --description="OpenStack Networking Service")

keystone endpoint-create --service-id="$NEUTRON_SERVICE" \
        --publicurl="http://{{NEUTRON_IP}}:9696" \
        --adminurl="http://{{NEUTRON_IP}}:9696" \
        --internalurl="http://{{NEUTRON_IP}}:9696"
