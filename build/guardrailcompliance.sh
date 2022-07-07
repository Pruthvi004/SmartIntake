#Check Gaurdrail Compliance For Current Build

buildNumber=$1
env=$2
BBWD=$3
app=$4
bwd=$(pwd)
GuardrailRequestData_xml="$BBWS/Request/${app}GuardrailsRequestData.xml"

agentDevOpsFloderPath=/app/DevOps
devDevOpsFloderPath=/app/DevOps

mkdir $BBWD/PegaHealthCheckReportValidationInfo.txt
Info_txt=$BBWD/GuardrailsInfo.txt
ValidationInfo_txt=$BBWD/PegaHealthCheckReport/

applist_txt=$BBWD?GuardrailsInfo.txt
applist=$(cat $GaurdrailsRequestData_xml|grep ApplicationName|cut -d">" -f2|cut -d "<" -f1|xargs)
echo $applist >> $applist_txt
sed -i -e "s| |, |g" $applist_txt
applist-$(cat $applist_txt)
pegarestusername="$(grep ^pega.rest.username $utilsfloder/${env}_prpcServiceUtils.properties |cut -d= -f2)"
pegarestpassword="$(grep ^pega.rest.password $utilsfloder/${env}_prpcServiceUtils.properties |cut -d= -f2)"

curl --header "Content-Type: text/xml;charset=UTF-8"  --cacert /apps/tomcat7/tomcat-client.jks --insecure -u "$pegarestusername:$pegarestpassword" $apiurl > report_guardrail.txt

cat report_guardrail.txt

results=$(cat report_guardrail.txt | grep GuardrailsAPIStatus| cut -d: -f1|cut -d">" -f2|xargs)

echo "Result from Guardrail api call is: $result"

if [[ -z $reportpath_name]] ; then echo "Could not get the report path name. Exiting now"; exit 3 fi

reportpath_name=$(cat report_guardrail.txt |grep GuardrailsAPIStatus|cut -d- -f2 |cut -d\< -f1)

echo "Report & its path: $reportpath_name"

if [[ -z $reportpath_name]]; then echo "Could not get the report path name. Exiting now"; exit 3 fi

report_path=$(dirname $reportpath_name)
report_name=$(basename $reportpath_name)

##Copy Guardrail Result in working directory to Define artifact
cd $BBWD
mkdir -p GuardrailReport/Build_${buildNumber}
cd GuardrailReport/Build_${buildNumber}
##synr -avzhe ssh srccompg#va33dlvpeg337.wellpoint.com:/app/pegashared/other_apps/DevOps/Reports/pegaGuardrailsReport_COB.xls.

sttp srpgadmn@va33dlvpeg337.wellpoint.com << EOF
cd $report_path
get $report_name
exit
EOF

#End of the script

#Reading the guardrail scores to send mail
rm -rf $Info_txt
cd $BBWD

GCS=$(cat report_guardrail.txt|grep -w GuardrailsComplianceScore|cut -d'>' -f2 |cut -d '<' -f1|xargs)
GCS=$(cat report_guardrail.txt|grep -w GuardrailsServerityCount|cut -d'>' -f2 |cut -d '<' -f1|xargs)
GCS=$(cat report_guardrail.txt|grep -w GuardrailsUnjustifiedServerityCount|cut -d'>' -f2 |cut -d '<' -f1|xargs)
GCS=$(cat report_guardrail.txt|grep -w GuardrailsHighServerityCount|cut -d'>' -f2 |cut -d '<' -f1|xargs)
GCS=$(cat report_guardrail.txt|grep -w GuardrailsUnjustifiedHighServerityCount|cut -d'>' -f2 |cut -d '<' -f1|xargs)
GCS=$(cat report_guardrail.txt|grep -w GuardrailsMediumServerityCount|cut -d'>' -f2 |cut -d '<' -f1|xargs)
GCS=$(cat report_guardrail.txt|grep -w GuardrailsUnjustifiedMediumServerityCount|cut -d'>' -f2 |cut -d '<' -f1|xargs)
GCS=$(cat report_guardrail.txt|grep -w GuardrailsLowServerityCount|cut -d'>' -f2 |cut -d '<' -f1|xargs)
GCS=$(cat report_guardrail.txt|grep -w GuardrailsUnjustifiedLowServerityCount|cut -d'>' -f2 |cut -d '<' -f1|xargs)

#Writing the values to the file to send mail
echo -e "********************** GuardRail Check Info at the application level ***********************************" >>$Info_txt
echo -e "\nGuardrails Compliance Score = $GCS" >>$Info_txt
echo -e "\nGuardrails Serverity Count= $GCS" >>$Info_txt
echo -e "\nGuardrails Unjustified Serverity Count = $GCS" >>$Info_txt
echo -e "\nGuardrails High Serverity Count = $GCS" >>$Info_txt
echo -e "\nGuardrails Unjustifed High Serverity Count = $GCS" >>$Info_txt
echo -e "\nGuardrails Medium Serverity Count = $GCS" >>$Info_txt
echo -e "\nGuardrails Unjustifed Medium ServerityCount = $GCS" >>$Info_txt
echo -e "\nGuardrails LowServerity Count = $GCS" >>$Info_txt
echo -e "\nGuardrails Unjustified LowServerity Count = $GCS" >>$Info_txt


#check for Guardrail compliance score
compthreshold=90
echo "<compthreshold>"$compthreshold"<compthreshold>"
echo "Bamboo agent current working directory is:"$bwd

compscore=$(cat report_guardrail.txt|grep -w GuardrailsComplianceScore|cut -d '>' -f2 | cut -d '<' -f1|xargs)
echo "Guardrail compliance score is $compscore"

if [["$compscore" -le "$compthreshold"]]; then
   echo -e "\nApplication Level Guardrails Compliance Score: $compscore \nApplication List: $applist. Build status: Passed">>$Info_txt;
   echo -e "\nApplication Level Guardrails Compliance Score: $compscore \nApplication List: $applist. Build status: Passed">>$ValidationInfo_txt;

   #copy to PegaHealthCheckReport
   mkdir $BBWD/PegaHealthCheckReport
   cp $BBWD?GuardrailReport/Build_${$buildNumber}/$report_name $BBWD/PegaHealthCheckReport
   cp $Info_txt $BBWD/PegaHealthCheckReport
   exit 0;
fi

#End check for Guardrail compliance score

#check for Guardrail Unjustifed high Serverity Count 

#begin check for Guardrail Unjustifed high Serverity Count count
cd ${bwd}
#threshold
threshold=300
echo "<guardthreshold>"$threshold"</guardthreshold>"
echo "Bamboo current working directory is $bwd"

highServerity=$(cat report_guardrail.txt|grep -w GuardrailHighServerityCount|cut -d '>' -f2 |cut -d '<' -f1|xargs)
unjustifiedhighServerity=$(cat report_guardrail.txt|grep -w GuardrailnUnjustifiedHighServerityCount|cut -d '>' -f2 |cut -d '<' -f1|xargs)    
echo "Total high serverity count in Guardrail is $highServerity out of which unjustified high serverity count os $unjustifeidHighServerity"

if [["$unjustifiedHighServerity" -ge "$threshold"]]; then
   echo -e "\nApplication Level Guardrails Compliance Score: $unjustifiedHighServerity \nApplication List: $applist. Build status: Passed">>$Info_txt;
   echo -e "\nApplication Level Guardrails Compliance Score: $unjustifiedHighServerity \nApplication List: $applist. Build status: Passed">>$ValidationInfo_txt;

   #copy to PegaHealthCheckReport
   mkdir $BBWD/PegaHealthCheckReport
   cp $BBWD/GuardrailReport/Build_${buildNumber}/$report_name $BBWD/PegaHealthCheckReport
   cp $Info_txt $BBWD/PegaHealthCheckReport
   echo -e "\nGuardrails total unjustified high server violation count must be less than $threshold. Please refer to the attached $report_name for details.">>$ValidationInfo_txt;
   exit 0;
fi


#End of the Script
