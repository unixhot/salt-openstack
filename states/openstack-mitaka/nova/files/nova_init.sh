#!/bin/bash
export OS_TENANT_NAME="{{KEYSTONE_ADMIN_TENANT}}"
export OS_USERNAME="{{KEYSTONE_ADMIN_USER}}"
export OS_PASSWORD="{{KEYSTONE_ADMIN_PASSWD}}"
export OS_AUTH_URL="{{KEYSTONE_AUTH_URL}}"

keystone user-create --name={{AUTH_NOVA_ADMIN_USER}} --pass={{AUTH_NOVA_ADMIN_PASS}} --email=nova@example.com
keystone user-role-add --user={{AUTH_NOVA_ADMIN_USER}} --tenant={{AUTH_NOVA_ADMIN_TENANT}} --role=admin

function get_id () {
    echo `"$@" | grep ' id ' | awk '{print $4}'`
}
		
NOVA_SERVICE=$(get_id \
keystone service-create --name=nova \
                        --type=compute \
                        --description="OpenStack Compute Service")

keystone endpoint-create --service-id="$NOVA_SERVICE" \
        --publicurl=http://{{NOVA_IP}}:8774/v2/%\(tenant_id\)s \
        --adminurl=http://{{NOVA_IP}}:8774/v2/%\(tenant_id\)s \
        --internalurl=http://{{NOVA_IP}}:8774/v2/%\(tenant_id\)s
