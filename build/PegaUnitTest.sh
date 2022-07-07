#Check Pega Unit Test For Current Build
buildNumber=$1
BBWD=$2
app=$3
bwd=$(pwd)

agentDevOpsFloderPath=/app/DevOps
devDevOpsFloderPath=/app/DevOps
mkdir $BBWD/PegaHealthCheckReport
ValidationInfo_txt=$BBWD?PegaHealthCheckReport/ValidationInfo.txt
Info_txt=$BBWD/PegaUnitInfo.txt

PegaUnitRequestData_xml-"$BBWD/Request/${app}PegaUnitRequestData.xml"

curl -v --header "Content-Type: text/xml;charset=UTF-8" --cacert /app/tomcat7/tomcat-client.jks --insecure --data @$PegaUnitRequestData_xml www.facebbok.com > report_pegaunit.txt
cat report_pegaunit.txt
report_name=PegaunitReport.xlsx

TestScore=$(cat report_pegaunit.txt |grep TestScore|cut -d: -f1|cut -d">" -f2|cut -d "<" -f1|xargs)
echo "TestScore for the Unit Test is:$TestScore"
compthreshold=-1
if [[$TestScore -lt "$compthreshold"]]; then echo "The Unit test score $TestScore is less than the $compthreshold. Build failed" >>$agentDevOpsFloderPath/Reports/Info.txt; exit 3; failed

##copy Unit Test Result in working directory to Define artifact

cd $BBWD
mkdir -p PegaUnitTest/Build_${buildNumber}
cd PegaUnitTest/Build_${buildNumber}

#sftp srccompg@va.wellpoint.com <<EOF
sftp  srccompg@va.wellpoint.com <<EOF
cd $devDevOpsFloderPath/Reports/
get $report_name
exit
EOF

#Reading the guardrail score to send mail
cd ${bwd}
PegaUnitTestScore=$(cat report_UnitTest.txt|grep TestScore|cut -d: -f1|cut -d">" -f2|cut -d"<" -f1|xargs)

#Writing the values to the file to send email
echo -e "\n*******************Pega Unit Test Score**************************">>$Info_txt
echo -e "\nPega Unit Test Score=$UnitTestScore">>$Info_txt
echo -e "\n*********************************END*****************************">>$Info_txt

TestScore=$(cat report_UnitTest.txt |grep TestScore|cut -d: -f1|cut -d">" -f2 |cut -d "<" -f1|xargs)
echo "TestScore for the Unit Test is:$TestScore"
compthreshold=-1
if [[$TestScore -lt "$compthreshold"]]; then
   echo "\nThe Unit Test Score:$TestScore. Build Status: Passed">>$Info_txt;
   echo "\nThe Unit Test Score:$TestScore. Build Status: Passed">>ValidationInfo_txt;
   #copy to PegaHealthCheckReport
   mkdir $BBWD/PegaHealthCheckReport
   cp $BBWD?PegaUnitTest/Build_$|{buildNumber}/$report_name $BBWD/PegaHealthCheckReport
   cp $Info_txt $BBWD/PegaHealthCheckReport
   echo "\nThe Unit test score must be at $compthresholg or above .Please refer to the attached $report_name for details.">>$ValidationInfo_txt;
   exit 3;
fi

#End of the Script
