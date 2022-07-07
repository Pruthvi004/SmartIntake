#Check Guardrail Compliance For Current Build
echo "####################### Check Guardrail Compliance For Product"

buildNumber=$1
env=$2
BBWD=$3
bwd=$(pwd)
INSKEY=$4

agentDevOpsFloderPath=/app/DevOps
devDevOpsFloderPath=/app/DevOps
mkdir $BBWD/PegaHealthCheckReport
ValidationInfo_txt=$BBWD/PegaHealthCheckReport/ValidationInfo.txt
Info_Product_txt=$BBWD/GuardrailsOnProductInfo.txt

GuardrailsOnProductRequestData_xml=$BBWD/Request/GuardrailsOnProductRequestData.xml

if [[| -z $INSKEY]];
then    
echo "Updating Product INS Key into $GuardrailsOnProductRequestData_xml";
sed -i -e "s|<ProductKey>.*</ProductKey>|<ProductKey>$INSKEY</ProductKey>|g" $GuardrailsOnProductRequestData_xml
updatedinskey-$( cat $GuardrailsOnProductRequestData_xml|grep ProductKey|cut -d">" -f2|cut -d "<" -f1|xargs)
if [["$INSKEY" |="$updatedinskey"]]; then echo "Product INS key updated to $GuardrailOnProductRequestData_xml file failed."; exit 3;
fi

cat $GuardrailsOnProductRequestData_xml
pegarestusername=$(cat $BBWD/config/server.properties |grep "pega.rest.username" |cut -d '=' -f2)
pegarestpassword=$(cat $BBWD/config/server.properties |grep "pega.rest.password" | cut -d '=' -f2)

curl --header "Content-Type: text/xml;charset=UTF-8"  --cacert /apps/tomcat7/tomcat-client.jks --insecure -u "$pegarestusername:$pegarestpassword" --data @${GuardrailsOnProductRequestData_xml}      >report_guardrailonproduct.txt

cat report_guardrailonproduct.txt

result=$(cat report_guardrailproduct.txt |grep GuardrailsAPISStatusOnProduct|cut -d: -f1|cut -d">" -f2|xargs)
reportpath_name=$(cat report_guardrailonproduct.txt |grep GuardrailsAPIStatusOnProduct|cut -d -f2 |cut -d\< -f1)

echo "Result from Guardrail api on product is :$result"
echo "Guardrail api on product Report & its path is :$reportpath_name"
if [[$result |="Success"]]; then echo "Guardrail API call failed.Exiting Now "; exit 3; fi

if [[-z $reportpath_name]]; then echo "Could not get the report path name.Exiting now"; exit 3; fi

report_path=$(dirname $reportpath_name)
report_name=$(basename $reportpath_name)

echo "Guardrail api on product Report name is : $report_name"

#copy Guardrail Result in working directory to Define artifactory
cd $BBWD
mkdir -p GuardrailReport/Build_${buildNumber}
cd GuardrailReport/Build_${buildNumber}
##rsync -avzhe ssh srccomp#jngnn .xls

sftp ah74979@wellpoint.com <<EOF
cd $report_path
get $report_name
exit
EOF

#end of the script

#Reading the Guradrail score to send email 
rm -rf $Info_Product_txt
cd $BBWD

GCS=$(cat report_guardrailonproduct.txt|grep -w GuardrailsComplianceScore|cut -d'>' -f2 |cut -d '<' -f1|xargs)
GCS=$(cat report_guardrailonproduct.txt|grep -w GuardrailsServerityCount|cut -d'>' -f2 |cut -d '<' -f1|xargs)
GCS=$(cat report_guardrailonproduct.txt|grep -w GuardrailsUnjustifiedServerityCount|cut -d'>' -f2 |cut -d '<' -f1|xargs)
GCS=$(cat report_guardrailonproduct.txt|grep -w GuardrailsHighServerityCount|cut -d'>' -f2 |cut -d '<' -f1|xargs)
GCS=$(cat report_guardrailonproduct.txt|grep -w GuardrailsUnjustifiedHighServerityCount|cut -d'>' -f2 |cut -d '<' -f1|xargs)
GCS=$(cat report_guardrailonproduct.txt|grep -w GuardrailsMediumServerityCount|cut -d'>' -f2 |cut -d '<' -f1|xargs)
GCS=$(cat report_guardrailonproduct.txt|grep -w GuardrailsUnjustifiedMediumServerityCount|cut -d'>' -f2 |cut -d '<' -f1|xargs)
GCS=$(cat report_guardrailonproduct.txt|grep -w GuardrailsLowServerityCount|cut -d'>' -f2 |cut -d '<' -f1|xargs)
GCS=$(cat report_guardrailonproduct.txt|grep -w GuardrailsUnjustifiedLowServerityCount|cut -d'>' -f2 |cut -d '<' -f1|xargs)
TotalRules=$(cat report_guardrailonproduct.txt| grep -w TotalRulesInProduct|cut -d '>' -f2 |cut -d '<' -f1|xargs)

#writing the values to the file to send email

echo -e "********************** GuardRail Check Info on Product ***********************************" >>$Info_Product_txt
echo -e "\nGuardrails Compliance Score = $GCS" >>$Info_Product_txt
echo -e "\nGuardrails Serverity Count= $GCS" >>$Info_Product_txt
echo -e "\nGuardrails Unjustified Serverity Count = $GUCS" >>$Info_Product_txt
echo -e "\nGuardrails High Serverity Count = $GHCS" >>$Info_Product_txt
echo -e "\nGuardrails Unjustifed High Serverity Count = $GUHCS" >>$Info_Product_txt
echo -e "\nGuardrails Medium Serverity Count = $GMCS" >>$Info_Product_txt
echo -e "\nGuardrails Unjustifed Medium ServerityCount = $GUMCS" >>$Info_Product_txt
echo -e "\nGuardrails LowServerity Count = $GLCS" >>$Info_Product_txt
echo -e "\nGuardrails Unjustified LowServerity Count = $GULCS" >>$Info_Product_txt
echo -e "\nGTotal Rules = $TotalRules">>$Info_Product_txt

#Check for Guardrail COmpliance score
compthreshold=90
echo "<compthresholdonproduct>$compthreshold<\compthresholdonproduct>"
echo "Bamboo current Working Directory is :$bwd"

compthresholdonproduct=$(cat report_guardrailonproduct.txt|grep -w GuardrailsComplianceScoreOnProduct|cut -d '>' -f2 |cut -d '<' -f1|xargs)
echo "Guardrail compliance score on product is $compscoreproduct"

if [["$compscoreonproduct" -le "$compthreshold"]]; then
#errormessage="\nProduct Level Guardrail Compliance Score: $compscoreonproduct ProductKey:$INSKEY , BUild Status: Failed";
errormessage="\nProduct Level Guardrails complaince Score: $compscoreproduct Product Key: $INSKEY.";
echo -$errormessage;
echo -e $errormessage >> $Info_Product_txt;
echo -e $errormessage >> $ValidationInfo_txt;
#Copy to PegaHealthCheckReport
mkdir $BBWD/PegaHealthCheckReport;
cp $BBWD/GuardrailReport/Build_${buildNumber}/$report_name $BBWD/PegaHealthCheckReport;
cp $Info_Product_txt $BBWD/PegaHealthCheckReport;
#exit 3;
fi
#End check for guardrail compliance score

#Check for Guardrail Unjustified high Derverity count count

#Begin check for Guardrail Unjustified high Serverity Count count

#threshold=15
threshold=10
echo "<guardrailthresholdonproduct>$threshold</guardrailthresholdonproduct>"
echo "Bamboo current working directory is:$bwd"

highServerity=$(cat report_guardrailonproduct.txt|grep -w GuardrailHighServerityCountOnProduct|cut -d '>' -f2 |cut -d '<' -f1 |xargs)
unjustifeidHighServerity=$(cat report_guardrailonproduct.txt|grep -w GuardrailUnjustifiedHighServerityCountOnProduct |cut -d '>' -f2 |cut -d '<' -f1 |xargs )
echo "Total high serverity count on product GFuardrail is $highServerity out of which unjustifeid high serverity count os $unjustifiedHighServerity"
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
