export OS_TENANT_NAME="admin"
export OS_USERNAME="admin"
export OS_PASSWORD="{{ADMIN_PASSWD}}"
export OS_AUTH_URL="http://{{CONTROL_IP}}:5000/v2.0/"

function get_id () {
    echo `"$@" | grep ' id ' | awk '{print $4}'`
}
		
CINDER_SERVICE=$(get_id \
keystone service-create --name=cinder \
                        --type=volume \
                        --description="OpenStack Block Storage")

keystone endpoint-create --service-id="$CINDER_SERVICE" \
        --publicurl=http://{{CONTROL_IP}}:8776/v1/%\(tenant_id\)s \
        --adminurl=http://{{CONTROL_IP}}:8776/v1/%\(tenant_id\)s \
        --internalurl=http://{{CONTROL_IP}}:8776/v1/%\(tenant_id\)s
