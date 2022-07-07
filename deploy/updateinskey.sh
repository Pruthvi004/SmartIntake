ENV=$1
INSKEY=$2
BBWD=$3
PostDeployRequestData_xml="$BBWD/Request/PostDeployRequestData.xml"

if [[! -z $INSKEY]];
then
echo "Updating Product INSKEY into $PostDeployRequestData_xml";
sed -i -e "s|<ProductInsKey>.*</ProductInsKey>|<ProductInsKey>$INSKEY</ProductInsKey>|g" $PostDeployRequestData_xml
updatedinskey=$(cat $PostDeployRequestData_xml|grep ProductInsKey |cut -d ">" -f2|cut -d "<" -f1|xargs)
if [["$INSKEY" !="$updatedinskey"]]; then echo "Product INSKEY updated to $PostDeployRequestData_xml file failed."; exit 3; fi
fi


if [[! -z $ENV]];
then
echo "Updating ENV into $PostDeployRequestData_xml";
sed -i -e "s|<TargetEnvName>.*</TargetEnvName>|<TargetEnvName>$ENV</TargetEnvName>|g" $PostDeployRequestData_xml
updatedenv=$(cat $PostDeployRequestData_xml| grep TargetEnvName|cut -d">" -f2|cut -d "<" -f1|xargs)
if [["$ENV" != "$updatedenv"]]; then echo "ENV update to $PostDeployRequestData_xml file failed.";exit 3; fi
fi

cat $PostDeployRequestData_xml