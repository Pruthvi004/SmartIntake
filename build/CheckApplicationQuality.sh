#Check Guardrail Compliance For Current Build

buildNumber=$1
env=$2
BBWD=$3
app=$4
RELEASE=$5
bwd=$(pwd)

GuardrailRequestData_xml="$BBWD/Request/GuardrailsRequestData.xml"
applist_txt=$BBWD/GuardrailsInfo.txt
applist=$(cat $GuardrailRequestData_xml|grep ApplicationName|cut -d">" -f2|cut -d"<" -f1|xargs)
echo $applist
echo $applist >> $applist_txt
sed -i -e "s| |, |g" $applist_txt
applist=$(cat $applist_txt)
echo $applist

GuardrailRequestData_xml=$(cat $BBWD/Request/ApplicationQualityRequestData.xml)
applicationqualitychecknotification_sh="$BBWD/build/SendPegHealthCheckNotification.sh"

agentDevOpsFloderPath=/app/DevOps 
devDevOpsFloderPath=/app/pegashared/other_apps/DevOps

mkdir $BBWD/PegaHealthCheckReport
ValidationInfo_txt=$BBWD/PegaHealthCheckReport/ValidationInfo.txt
Info_txt=$BBWD/GuardrailsInfo.txt

utilsfloder=$BBWD/prpcServiceUtils_84/scripts/utils/
envurl="$(grep ^pega.rest.server.url $utilsfloder/${env}_prpcServiceUtils.properties |cut -d= -f2)"
apiurl=""$envurl/PegaUnit/Pega-Landing-Application/pzGetApplicationQualityDetails/GuardrailRequestData_xml""
apiurl=${apiurl%$'\r'}
replacecompliancescore="${env}GuardrailsComplianceScore"


echo "envurl: $envurl"
echo "apiurl: $apiurl"
echo "replacecompliancescore: $replacecompliancescore"

pegarestusername="$(grep ^pega.rest.username $utilsfloder/${env}_prpcServiceUtils.properties |cut -d= -f2)"
pegarestpassword="$(grep ^pega.rest.password $utilsfloder/${env}_prpcServiceUtils.properties |cut -d= -f2)"

curl -v -X POST --header "Content-Type: text/xml;charset=UTF-8"  --cacert /apps/tomcat7/tomcat-client.jks --insecure -u "$pegarestusername:$pegarestpassword" $apiurl > report_guardrail.txt

compscore=$(cat report_guardrail.txt |grep -oP '(?=<Compliancescore>).*?(?=</Compliancescore>)')
compscore=$(echo "$compscore" | awk 'BEGIN {FS= "."}{print $1}')

sed -i -e "s|Compliancescore| $replacecompliancescore|g" report_guardrail.txt

cat report_guardrail.txt

#Check for Guardrail compliance score
compthreshold=90
echo "<compthreshold>"$compthreshold"<compthreshold>"
echo "Bamboo current working directory is: $bwd"
echo "Guardrail compliance score is: $compscore"

if [[$compscore -le $compthreshold]] ; then
    echo -e "\nApplication Level Guardrails Compliance score: $compscore \nApplication List: $applist.">>$Info_txt;
    echo -e "\nApplication Level Guardrails Compliance score: $compscore \nApplication List: $applist.">>$ValidationInfo_txt;
    if [["$env"=="PERF"]] ; then
       echo -e "Build Status: Failed" >>$ValidationInfo_txt;
    else 
       echo -e "Build Status: Passed" >>$ValidationInfo_txt;
    fi
    $applicationqualitychecknotification_sh $BBWD $buildNumber "$env Deployment" "$RELEASE" $env
    if [["$env"=="PERF"]] ; then
       echo -e "PERF guardrails check validation failed"
       #exit 3;
    fi
fi

#End check for Guardrail compliance score
