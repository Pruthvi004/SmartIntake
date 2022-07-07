#Release Notes Creation
en=$1
#en=${bamboo.ENV}
build=$2
#build=${bamboo.buildNumber}
app=$3
bwd=$(pwd)

agentDevOpsFloderPath=/apps/DevOps
devDevOpsFloderPath=/apps/DevOps

featureFile="$agentDevOpsFloderPath/Request/${app}FeatureIDList.xml"
featureFile_SIT="$agentDevOpsFloderPath/Request/${app}FeatureIDList_SIT.xml"
featureFile_PERF="$agentDevOpsFloderPath/Request/${app}FeatureIDList_PERF.xml"
featureFile_CI="$agentDevOpsFloderPath/Request/${app}FeatureIDList_CI.xml"
featureFile_UAT="$agentDevOpsFloderPath/Request/${app}FeatureIDList_UAT.xml"

sftp srcwpd@va33.wellpoint.com <<EOF
lcd $agentDevOpsFloderPath/Request
chmod 755 $devDevOpsFloderPath/Request/${app}FeatureIDlist.xml
cd $devDevOpsFloderPath/Request
get ${app}FeatureIDlist.xml
exit
EOF

update=$(cat $featureFile)

echo $update

echo $update >> ${featureFile_CI}
echo $update >> ${featureFile_SIT}
echo $update >> ${featureFile_PERF}
echo $update >> ${featureFile_UAT}
