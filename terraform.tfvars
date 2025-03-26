# general oci parameters

api_fingerprint      = "c2:d9:b9:45:05:1b:8d:64:0f:71:34:13:c9:86:21:12"
api_private_key_path = "/Users/anw/.oci/keys_t.pem"

home_region = "us-ashburn-1"
region      = "ap-mumbai-1"
tenancy_id  = "ocid1.tenancy.oc1..aaaaaaaalylrk6bjiuxqryukd6jrlxgfbwjuulnavxqehvv3crknt7ewhlpa"
user_id     = "ocid1.user.oc1..aaaaaaaatrqrjqypybmqqomamyyuzdjjclaws3fox4cz6v6cmxhlbfsdediq"


compartment_id = "ocid1.compartment.oc1..aaaaaaaazkbiglujngzerf6f2zi4uzfy6akurxhevpya7xvi6c7geoh4e6ka"

############################### Virtual Cloud Network #############################################################

vcn1_vcn_display_name = "vcn1_VCN"
vcn1_vcn_dns_label    = "vcn1vcn"
vcn1_vcn_cidr_block   = ["10.0.0.0/16"]

# Subnet Configurations
public_subnet_cidr_block   = "10.0.1.0/24"
public_subnet_display_name = "PublicSubnet"
#public_subnet_dns_label = "publicsubnet"

db_subnet_cidr_block   = "10.0.2.0/24"
db_subnet_display_name = "DBSubnet"
#db_subnet_dns_label = "dbsubnet"

# Security List Configurations
public_ingress_rules = [
  { protocol = "6", source = "0.0.0.0/0", min = 22, max = 22 },  # SSH
  { protocol = "6", source = "0.0.0.0/0", min = 80, max = 80 },  # HTTP
  { protocol = "6", source = "0.0.0.0/0", min = 443, max = 443 } # HTTPS
]

#public_egress_rules = ["0.0.0.0/0"] # Allow all outbound traffic

db_ingress_rules = [
  { protocol = "6", source = "10.0.1.0/24", min = 22, max = 22 },        # SSH from Public Subnet
  { protocol = "6", source = "10.0.1.0/24", min = 3389, max = 3389 },    # RDP from Public Subnet
  { protocol = "6", source = "10.0.1.0/24", min = 5432, max = 5432 },    # PostgreSQL
  { protocol = "6", source = "10.0.1.0/24", min = 6379, max = 6379 },    # Redis
  { protocol = "1", source = "0.0.0.0/0", icmp_type = 3, icmp_code = 4 } # ICMP Ping
]

#db_egress_rules = ["0.0.0.0/0"] # Allow all outbound traffic

public_egress_rules = [
  {
    protocol    = "all"
    destination = "0.0.0.0/0"
  }
]

db_egress_rules = [
  {
    protocol    = "all"
    destination = "0.0.0.0/0"
  }
]

############################### NETWORK CONFIGURATION FOR POSTGRESQL #####################################################################

#db_subnet_id = "ocid1.subnet.oc1.ap-mumbai-1.aaaaaaaafnamnnevgt7iua5t4k7fstrxzfxbnvtl7s25ynyohqobf2adx2va"
is_reader_endpoint_enabled     = false
nsg_ids                        = []
primary_db_endpoint_private_ip = null

############################## POSTGRESQL DATABASE #########################################################
db_system_db_version                  = 14
db_system_display_name                = "psql-terraform"
db_system_shape                       = "PostgreSQL.VM.Standard.E4.Flex"
db_system_instance_memory_size_in_gbs = 40
db_system_instance_ocpu_count         = 3
db_system_instance_count              = 3

psql_iops_input = 75

db_system_credentials_username = "admin"
password_type                  = "PLAIN_TEXT"
password                       = "Welcome123###"

enable_read_replicas = false


backup_start   = "00:00"
backup_kind    = "DAILY"
retention_days = 7


backup_display_name      = "daily_backup"
backup_description       = "Backup for PostgreSQL DB"
backup_retention_period  = 7
maintenance_window_start = "SUN 02:00"





####################### CONFIG  ############################################
/*
Creation of Custom configuration - customization of User variables
Eg: Max_connetions = 500

*/

config_db_version                  = "15"
config_display_name                = "prod-psql-config"
config_shape                       = "VM.Standard.E4.Flex"
config_key                         = "max_connections"
overridden_config_value            = "500"
config_description                 = "Production PostgreSQL configuration"
config_instance_memory_size_in_gbs = 16
config_instance_ocpu_count         = 4
config_is_flexible                 = true




############################ DB Custom #######################################

databases = ["xyz-db"]
port      = 5432
host      = "127.0.0.1"

##################################################################################
#                           MONITORING                                           #


###########################  Notification #######################################

notification_topic_name        = "PostgreSQL_Alerts"
notification_topic_description = "Topic for PostgreSQL Alerts"

##########################  Subscription  ######################################

endpoint = "angeline.hilda.w@xyz.com"
protocol = "EMAIL"


##########################  Alarms      #######################################
#alarm_namespace for Postgresql is oci_postgresl
#resourceType is OCI_OPTIMIZED_STORAGE

# Refer this for other PostgreSQL Metrics: https://docs.oracle.com/en-us/iaas/Content/postgresql/metrics.htm

# Eg:"CpuUtilization[1m]{resourceType=\"OCI_OPTIMIZED_STORAGE\",dbInstanceRole=\"PRIMARY\"}.percentile(0.9) > 5" 
# The query computes the 90th percentile CPU utilization every 1 minute and trigeers alarm if the value exceeds 5% ( Test case)

#alarm_pending_duration is set to  "PT5M"
# So the Alarm is triggered if the CPU spike is above 5% over a period of 5 minutes

#alarm_query = "CpuUtilization[1m]{resourceType=\"OCI_OPTIMIZED_STORAGE\",dbInstanceRole=\"PRIMARY\"}.percentile(0.9) > 5"

alarm_namespace = "oci_postgresql"
destinations    = ["ocid1.onstopic.oc1.ap-mumbai-1.amaaaaaazxsy2naawr2tssmbtwrktwfxl7ymiepcrhqbbhebcioelbkyruoa"]



alarm_pending_duration = "PT1M"
alarm_message_format   = "ONS_OPTIMIZED"

cpu_utilization_alarm_threshold = 60
db_connections_alarm_threshold  = 100 #count
write_latency_alarm_threshold   = 200 #ms
read_latency_alarm_threshold    = 150 #ms
used_storage_alarm_threshold    = 80  #GB



