#Post Deployment Check
ENV=$1
buildNumber=$2
INSKEY-$3
BBWD=$4
bwd=$(pwd)

agentDevOpsFloderPath=/apps/DevOps
devDEvOpsFloderPath=/apps/DevOps

postDeployRequestData_xml="$BBWD/Request/PostDeployRequestData.xml"
postDeployNotification_sh="$BBWD/deploy/postDeployNotification.sh"

#cp /local_home/srcwgspf/DevOps/Request/${PostDeployRequestData_xml}.

if [[! -z $INSKEY]];
then    
echo "Updating Product INSKEY into $postDeployRequestData_xml";
sed -i -e "s|<ProductInsKey>.*</ProductInsKey>|<ProductInsKey>$INSKEY</ProductInsKey>|g" $postDeployRequestData_xml
updatedinskey= $(cat $postDeployRequestData_xml|grep ProductInsKey |cut =d ">" -f2 |cut -d "<" -f1|xargs)
if [["$INSEY" != "Sucess"]]; then echo "PostDeployment API call failed."; exit 3; fi
fi

cat $PostDeployRequestData_xml

curl --header "Content_type: text/xml;charset=UTF-8" --cacert /apps/tomcat7/tomcat-client.jks --insecure --data @${PostDeployRequestData_xml} va33.wellpoint.com >report_rulecountcompare.txt
#curl --header "Content_type: text/xml;charset=UTF-8" --cacert /apps/tomcat7/tomcat-client.jks --insecure --data @${PostDeployRequestData_xml} va33.wellpoint.com >report_rulecountcompare.txt

cat report_rulecountcompare.txt

result= $(cat report_rulecountcompare.txt |grep PostDeployStatus|cut -d: -f1|cut -d ">" -f2|xargs)
reportpath_name=$(cat report_rulecountcompare.txt |grep PostDeployStatus |cut -d- -f2 |cut -d\< -f1)

echo "Results from PostDeployment api call is :$result"

if [[ $result != "Sucess"]]; then echo "PostDeployment API call failed."; exit 3; fi

echo "Report & its path: $reportpath_name"
report_path=$(dirname $reportpath_name)
report_name=$(basename $reportpath_name)

##Copy PostDeployment Report in Working Directory to Define artifact
cd $BBWD
mkdir -p PostDeploymentReport/Build_${buildNumber}
cd PostDeploymentReport/Build_${buildNumber}
echo "Current working directory is :$PWD"

sftp srpgadm@ca33.wellpoint.com <<EOF
lcd $BBWD/PostDeployment/Build_${buildNumber}
cd $report_path
chmod 777 $reportpath_name
get $report_name
#rm CompareResult*.xlsx
exit
EOF


#Begin Check for Post Deploy Rule Count Match
rm -rf $BBWD/Deployment_Info.txt
cd ${bwd}
echo "Bamboo current working directory is :$bwd"
doesCountMatch=$(grep doesCountMatch report_rulecountcompare.txt |cut -d '>' -f2|cut -d '<' -f1)
#doesCountMatch
echo "Does Rule Count match in Post Deploy Check:$doesCountMatch "
if [["$doesCountMatch" =="Yes"]]; then echo "Deployment is completed in $ENV enviornment. And the rules count match in the post deploy check.">>$BBWD/Deployment_Info.txt;fi
if [["$doesCountMatch" =="Yes"]];then
    echo "Rule count does not match in $ENV as compared with DEV . For additional information please refer to attached document $report_name.">>$BBWD?Deployment_Info.txt;
    $postDeployNotification_sh $DEV $buildNumber "$ENV Deployment " $BBWD
    exit 3;
fi
#End check for Post Deploy Count Match
