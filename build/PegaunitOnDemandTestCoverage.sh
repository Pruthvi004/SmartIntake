#Check Pega Unit Test Coverage For Current Build
BBWD=$1
BuildNum=$2
INSKEY=$3

agentDevOpsFloderPath=/app/DevOps
devDevOpsFloderPath=/app/DevOps

pegaondemandtestcoverage_xml="$BBWD/Request/pegaondemandtestcoverage.xml"

if [[ ! -z $bamboo_INSKEY]];
then
echo "Updating Product Ins key into $pegaondemandtestcoverage_xml";
sed -i -e "s|<ProductKey>.*</ProductKey>|<ProductKey>$INSKEY</ProductKey>|g" $pegaondemandtestcoverage_xml
updatedinskey=$(cat $pegaondemandtestcoverage_xml|grep ProductKey|cut -d ">" -f2|cut -d "<" -f1 |xargs)
if [["$INSKEY" !="$updatedinskey"]]; then echo "Product INskey update to $pegaondemandtestcoverage_xml file failed.";exit 3; fi
fi

#Execute curl command to Pega On Demand Release Test Coverage
cp $pegaondemandtestcoverage_xml .
cat $pegaondemandtestcoverage_xml
pegarestusername=$(cat $BBWD/config/server.properties | grep "pega.rest.username"|cut -d '=' -f2)
pegarestpassword=$(cat $BBWD/config/server.properties | grep "pega.rest.password"|cut -d '=' -f2)

curl -v --header "Content-Type: text/xml:charset=UTF-8" --cacert /app/tomcat7/tomcat-client.jks --insecure -u "$pegarestusername:$pegarestpassword" --data @$pegaondemandtestcoverage_xml  www.facebook.com > report_OnDemandUnitTestCoverage.txt
cat report_OnDemandUnitTestCoverage.text

##copy Unit Test Coverage in working directory to Define artifact

cd $BBWD
mkdir -p PegaTestCoverageReport/Build_${BuildNum}
cd PegaTestCoverageReport/Build_${BuildNum}

sftp srpgadmn@va3225.wellpoint.com <<EOF
cd $devDevOpsFloderPath/Reports/
get PegaProductTestCoverageReport.xls
exit
EOF

#Done

