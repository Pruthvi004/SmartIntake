#en=${bamboo.ENV}
build=$2
#build=${bamboo.buildNumber}
pr=$3
bwd=$(pwd)

rmfile="$(pwd)/build/Request/RMRequestData_$en.xml"
rmfile_SIT="$(pwd)/build/Request/RMRequestData_SIT.xml"
rmfile_PERF="$(pwd)/build/Request/RMRequestData_PERF.xml"
rmfile_CI="$(pwd)/build/Request/RMRequestData_CI.xml"
rmfile_CRT="$(pwd)/build/Request/RMRequestData_CRT.xml"









sftp srcwpd@va33.wellpoint.com <<EOF
lcd /apps/pegashared/other_apps/Devops/Request
chmod 755 /app/pegashares/other_apps/DevOps/Request/FeatureIDList.xml
cd /apps/pegashared/other_apps/DevOps/Request
get FeatureIDlist.xml
exit
EOF

update= $(cat /apps/pegashared/other_apps/DEvOps/Request/FeatureIDList.xml)

echo $update

sed -i "/<RMTableInput>/a $update"${rmfile}
echo $rmfile
sed -i "/<RMTableInput>/a $update"${rmfile_SIT}
sed -i "/<RMTableInput>/a $update"${rmfile_PERF}
sed -i "/<RMTableInput>/a $update"${rmfile_CI}
sed -i "/<RMTableInput>/a $update"${rmfile_CRT}