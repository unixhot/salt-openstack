export OS_SERVICE_TOKEN="{{KEYSTONE_ADMIN_TOKEN}}" 
export OS_SERVICE_ENDPOINT="{{KEYSTONE_AUTH_URL}}"

keystone user-create --name={{KEYSTONE_ADMIN_USER}} --pass="{{KEYSTONE_ADMIN_PASSWD}}"
keystone tenant-create --name={{KEYSTONE_ADMIN_TENANT}} --description="Admin Tenant"
keystone role-create --name={{KEYSTONE_ROLE_NAME}}
keystone user-role-add --user={{KEYSTONE_ADMIN_USER}} --tenant={{KEYSTONE_ADMIN_TENANT}} --role={{KEYSTONE_ROLE_NAME}}
keystone user-role-add --user={{KEYSTONE_ADMIN_USER}} --role=_member_ --tenant={{KEYSTONE_ADMIN_TENANT}}
keystone tenant-create --name=service

function get_id () {
    echo `"$@" | grep ' id ' | awk '{print $4}'`
}
#Keystone Service and Endpoint                                     
KEYSTONE_SERVICE_ID=$(get_id \
keystone service-create --name=keystone \
                        --type=identity \
                        --description="Keystone Identity Service")
keystone endpoint-create --service-id="$KEYSTONE_SERVICE_ID" \
    --publicurl="http://{{KEYSTONE_IP}}:5000/v2.0" \
    --adminurl="http://{{KEYSTONE_IP}}:35357/v2.0" \
    --internalurl="http://{{KEYSTONE_IP}}:5000/v2.0"
