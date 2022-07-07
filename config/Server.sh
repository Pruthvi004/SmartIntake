BBWD=$1
PWD=$BBWD/config
KEY=$3
WD=$BBWD/prpcServiceUtils_84/prpcServiceUtils/scripts/prpcServiceUtils

echo "Starting Decryption Process"

openssl enc -aes-256-cbc -d -in $PWD/server.dat -out $PWD/server.properties -k "$KEY"0

pegarestusername= $(cat $PWD/server.properties|grep "pega.rest.username" | cut -d '=' -f2)
pegarestpassword= $(cat $PWD/server.properties|grep "pega.rest.password" | cut -d '=' -f2)
produsername= $(cat $PWD/server.properties|grep "produsername" | cut -d '=' -f2)
prodpassword= $(cat $PWD/server.properties|grep "prodpassword" | cut -d '=' -f2)
keyStorePassword= $(cat $PWD/server.properties|grep "keyStorePassword" | cut -d '=' -f2)
trustStorePassword= $(cat $PWD/server.properties|grep "trustStorePassword" | cut -d '=' -f2)

sed -i -e 's|pega.rest.username=|pega.rest.username='$pegarestusername '|g '$WD/DEV_prpcServiceUtils.properties $WD/PERF_prpcServiceUtils.properties $WD/UAT_prpcServiceUtils.properties $WD/SIT_prpcServiceUtils.properties

sed -i -e 's|pega.rest.password=|pega.rest.password='$pegarestpassword '|g' $WD/DEV_prpcServiceUtils.properties $WD/PERF_prpcServiceUtils.properties $WD/UAT_prpcServiceUtils.properties $WD/SIT_prpcServiceUtils.properties

sed -i -e 's|trustStorePassword=|trustStorePassword='$trustStorePassword '|g' $WD/DEV_prpcServiceUtils.properties $WD/PERF_prpcServiceUtils.properties $WD/UAT_prpcServiceUtils.properties $WD/SIT_prpcServiceUtils.properties $WD.PROD_prpcServiceUtils.properties

sed -i -e 's|keyStorePassword=|keyStorePassword='$keyStorePassword'|g' $WD/DEV_prpcServiceUtils.properties $WD/PERF_prpcServiceUtils.properties $WD/UAT_prpcServiceUtils.properties $WD/SIT_prpcServiceUtils.properties $WD.PROD_prpcServiceUtils.properties

sed -i -e 's|pega.rest.username=|pega.rest.username='$pegarestusername'|g' $WD.PROD_prpcServiceUtils.properties

sed -i -e 's|pega.rest.password=|pega.rest.password='$pegarestpassword '|g' $WD.PROD_prpcServiceUtils.properties