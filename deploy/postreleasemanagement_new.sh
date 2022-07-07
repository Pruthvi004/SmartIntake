#Release Notes Creation
en=$1
#en=$(bamboo.buildNumber)
build=$2
#build=${bamboo.buildNumber}
bwd=$(pwd)

agentDevOpsFloderpath=/apps/agentDevOpsFloder
devDevOpsFloderPath=/apps/Devops

#Zero Out FeatureIDList.xml XML on bamboo server
echo >$agentDevOpsFloderPath/Request/${app}FeatureIDList.xml

#Remove FeatureIDList.xml XML from dev server
#ssh srcwpd@va33.wellpoint.com rm -rf /apps/pegasharedfloder/other_apps/DevOps/Requestr/FeatureIDlist.xml
#sftp srewpgadmin@va33.wellpoint.com <<EOF
sftp srcwpgadm@va33.wellpoint.com <<EOF
cd $devDevOpsFloderPath/Request/
rm ${app}FeatureIDlist.xml
exit
EOF
