#set connection data accordingly

source_host=*
source_port=*
source_passwd=*
source_db=0

target_host=*
target_port=*
target_passwd=*
target_db=0

redis-cli -h $source_host -p $source_port -n $source_db -a $source_passwd --scan | while read key; do echo "$key"; redis-cli -h $source_host -p $source_port -n $source_db -a $source_passwd MIGRATE $target_host $target_port "$key" $target_db 1000 COPY REPLACE AUTH $target_passwd; done
