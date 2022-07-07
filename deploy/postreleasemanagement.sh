#Release Notes creation
en=$1
#en=${bamboo.ENV}
build=$2
#build=${bamboo.buildNumber}
pr=$3

bwd=$(pwd)

#zero out FeatureIDlist.xml XML on bamboo server
echo > /apps/DevOps/Request/FeatureIDList.xml

#Remove FeatureIDList.xml from dev server
#ssh srcwpd@va33.wellpoint.com rm -rf /apps/pegasharedfloder/other_apps/DevOps/Requestr/FeatureIDlist.xml
#sftp srewpgadmin@va33.wellpoint.com <<EOF
sftp srcwpd@va33.wellpoint.com <<EOF
cd /apps/pegashared/other_apps/DEvOps/Request/
rm -rf FeatureIDlist.xml
exit 
EOF