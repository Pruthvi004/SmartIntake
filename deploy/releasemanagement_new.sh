#Release Notes Creation
en=$1
#en=${bamboo.ENV}
build=$2
#build=${bamboo.buildNumber}
pr=$3
BBWD=$4
app=$5
pwd=$(pwd)

agentDevOpsFloderPath=/apps/Devops
devDevOpsFloderPath=/apps/DevOps

featureFile="$agentDevOpsFloderPath/Request/${app}FeatureIDList_$en.xml"
rmfile= "$BBWD/Request/RMRequestData/xml"

#ssh srcwgpg@va33.wellpoint.com rm -rf /apps/pegashared/other_apps/DevOps/Reports/ReleaseNotes_MajorCI.xls
#ssh srcwgpg@va33.wellpoint.com rm -rf /apps/pegashared/other_apps/DevOps/Reports/ReleaseNotes_MajorCI.xls

update=$(cat $featureFile)
echo $update
#sed -i -e "s|<RMTableInput>|<RMTableInput>$update|g" $rmfile
chmod -R 0777 $agentDevOpsFloderPath/Request
chmod 0777 $rmfile
sed -i "<RMTableInput>/a $update "$rmfile;
chmod -R 0777 $agentDevOpsFloderPath/Request
cat $rmfile

sed -i -e "s|<EnvName>.*</EnvName>|<EnvName>$en</EnvName>|g" $rmfile
sed -i -e "s|<BuildNumber>.*</BuildNumber>|<BuildNumber>$build</BuildNumber>|g" $rmfile
sed -i -e "s|<ProductForFeatureID>.*</ProductForFeatureID>|<ProductForFeatureID>$pr</ProductForFeatureID>|g" $rmfile

cp $rmfile .
cat $rmfile

curl --header "Content-Type: text/xml;charset=utf-8" --cacert /apps/tomcat7/tomcat-client.jks --insecure --data @RMRequestData.xml va33.wellpoint.com > report_RMRequestData_$en.txt

cat report_RMRequestData_$en.txt

result= $(cat report_RMRequestData_$en.txt|grep RMTableUpdateStatus|cut -d: -f1|cut -d ">" -f2|xargs)

echo "Result from ReleaseManagement api call is :$result"

if [[$result != "Success" ]]; then echo "ReleaseManagement API call failed.";exit 3; fi

#reportpath_name=#(cat report_RMRequestData_$en.txt |grep RMTableUpdateStatus|cut -d "=" -f2|cut -d "<" -f1|cut -d- -f2|xargs)

reportpath_name="$devDevOpsFloderPath/Reports/ReleaseNotes_$en.xls"

echo "Report & its path: $reportpath_name"

#if [[-z $reportpath_name ]]; then echo "Could not get report path name. Exiting Now.";exit 3; fi

report_path=$(dirname $reportpath_name)
report_name=$(basename $reportpath_name)
echo "Report path: $reportpath"
echo "Report name: $reportname"

#if [[$? -ne 0]]; then echo "Could not get the report path name . Exiting Now.";exit 3; fi

#ssh srcwgpg@va33.wellpoint.com sudo /bin/chown -R srcwgpg /apps/pegashared/other_apps

#Copy Release Notes Report in working directory to Define Artifact
cd $BBWD
mkdir -p ReleaseNotesReport/Build_${build}

cd $BBWD/ReleaseNotesReport/Build_${build}

#sftp va33.wellpoint.com << EOF
sftp srcwgpg@va33.wellpoint.com << EOF
cd $report_path
get ReleaseNotes_${en}.xls
exit
EOF

rm -rf $featureFile
