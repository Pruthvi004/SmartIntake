#Check Pega Unit Test Coverage For Current Build
buildNumber=$1
BBWD=$2
app=$3
bwd=$(pwd)

agentDevOpsFloderPath=/app/DevOps
devDevOpsFloderPath=/app/DevOps

PegaCoverageRequestData_xml="$BBWD/Request/${app}PegaCoverageRequestData.xml"
pegarestusername=$(cat $BBWD/config/server.properties |grep "pega.rest.username" |cut -d '=' -f2)
pegarestpassword=$(cat $BBWD/config/server.properties |grep "pega.rest.password" |cut -d '=' -f2)

curl -v --header "Content_type: text/xml:charset=UTF-8" --cacert /apps/tomcat7.tomcat-client.jks --insecure -u "$pegarestusername:$pegarestpassword" --data @$PegaCoverageRequestData_xml www.wellpoint.com  > report_pegacoverage.txt

cat report_pegacoverage.txt
reportpath_name=$(cat report_pegacoverage.txt| grep TestCoverageStatus | cut -d- -f2| cut -d\< -f1)

echo "Report & its path: $reportpath_name"
report_path=$(dirname $reportpath_name)
report_name=$(basename $reportpath_name)
##Copy Unit Test Coverage In Coverage in Working directory to Define artifact

cd $BBWD
mkdir -p PegaTestCoverageReport/Build_${buildNumber}
cd PegaTestCoverageReport/Build_${buildNumber}

#sftp srccomp@va12.wellpoint.com <<EOF
sftp srccompg@va12.wellpoint.com <<EOF
cd $report_path
get $report_name
exit
EOF

#Done
