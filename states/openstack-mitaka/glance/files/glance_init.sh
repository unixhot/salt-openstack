export OS_TENANT_NAME="{{KEYSTONE_ADMIN_TENANT}}"
export OS_USERNAME="{{KEYSTONE_ADMIN_USER}}"
export OS_PASSWORD="{{KEYSTONE_ADMIN_PASSWD}}"
export OS_AUTH_URL="{{KEYSTONE_AUTH_URL}}"

keystone user-create --name={{AUTH_GLANCE_ADMIN_USER}} --pass={{AUTH_GLANCE_ADMIN_PASS}} --email=glance@example.com 
keystone user-role-add --user={{AUTH_GLANCE_ADMIN_USER}} --tenant={{AUTH_GLANCE_ADMIN_TENANT}} --role=admin

function get_id () {
    echo `"$@" | grep ' id ' | awk '{print $4}'`
}
		
GLANCE_SERVICE=$(get_id \
keystone service-create --name=glance \
                        --type=image \
                        --description="OpenStack Image Service")

keystone endpoint-create --service-id="$GLANCE_SERVICE" \
        --publicurl="http://{{GLANCE_IP}}:9292" \
        --adminurl="http://{{GLANCE_IP}}:9292" \
        --internalurl="http://{{GLANCE_IP}}:9292"
