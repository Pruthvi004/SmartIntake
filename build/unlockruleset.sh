env=$1
INSKEY=$2
BBWD=$3
buildNumber=$4
planName=$5
bwd=(pwd)

HandleVersionRequestData_xml="$BBWD/Request?HandleVersionRequestData$env.xml"


#Modify the INS KEY in the Request data file in any new key provided
if [[! -z $bamboo_INSKEY]];
then
echo "Updating Product INSKEY into $HandleVersionRequestData_xml";
sed -i e "s|<ProductInsKey>.*</ProductInsKey>|<ProductInsKey>$INSKEY</ProductInsKey>|g" $HandleVersionRequestData_xml
updatedinskey=$(cat $HandleVersionRequestData_xml|grep ProductInsKey| cut -d ">" -f2 |cut -d "<" -f1|xargs)
if ["$INSKEY"! = "$updatedinskey"]; then echo "Product INS key update to $HandleVersionRequestData_xml file failed"; exit 3; fi
fi 

#Execute ruleset check
cp $HandleVersionRequestData_xml

curl --header "Content-Type: text/xml;charset-UTF-8 " --cacert /apps/tomcat7/tomcat-client.jks --insecure --data @$HandleVersionRequestData_xml www.ca21.wellpoint.com > report_HandleVersion.txt
cat report_HandleVersion.text
result= $(cat report_HandleVersion.txt |grep HandleVersionStatus|cut -d: -f1| cut -d">" -f2 |xargs)
echo "Result from Handle unlock version api call is:$result"
if [[$result ! ="Success"]];then echo "Handle unlock API call failed.";
sh $BBWD/build/unlockrulenotification.sh $buildNumber $planName $BBWD
exit 3; fi
#Done
