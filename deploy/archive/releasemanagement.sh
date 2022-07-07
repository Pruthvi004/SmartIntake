#Release Notes Creation
en=$1
#en=${bamboo.ENV}
build=$2
#en=${bamboo.buildNumber}
pr=$3
ExportProductRequestData_xml=ExportProductRequestData_$en.xml
bwd=$(pwd)

rmfile="$(pwd)/build/Request/RMRequestData_$en.xml"
basermname="$(pwd)/build/Request/RMRequestData.xml"

#ssh srcwgspg@va33.wellpoint.com rm -rf /apps/pegashared/other_apps/DevOps/Reports/ReleaseNotes_MajorCI.xls
#ssh srcwgspg@va33.wellpoint.com rm -rf /apps/pegashared/other_apps/DevOps/Reports/ReleaseNotes_MajorSIT.xls

#rsyn -avzhe ssh srcwgspg@va33.wellpoint.com:/apps/pegashared/other_apps/DevOps/Request/FeatureIDList.xml /apps/pegashared/other_apps/DevOps/Request/
sftp srcwgpg@va33.wellpoint.com <<EOF
cd /apps/DevOps/Request/
ger FeatureIDList.xml 
exit
EOF

sed -i -e "s|<EnvName>.*</EnvName>|<EnvName>$en</EnvName>|g" $rmfile
sed -i -e "s|<BuildName>.*</BuildName>|<BuildName>$buildname</BuildName>|g" $rmfile

#pr=$(sed -n 's:.* <ProductInsKey>\(.*\)</ProductInsKey>.*:p' local_home/srcwgspg/DevOps/Request/ExportProductRequestData_${en}.xml)
sed -i -e "s/<ProductFeatureID>.*</ProductFeatureID>|<ProductInsKey>$pr</ProductInsKey>|g" $rmfile

#update=$(cat /apps/pegashared/other_apps/DevOps/Request/FeatureIDList.xml)

#sed -i "/<RMTableInput> a$update" ${rmfile}

cat $rmfile
cp $rmfile .
cat $rmfile 

curl --header "Content-Type: text/xml;charset=utf-8" --cacert /apps/tomcat7/tomcat-client.jks --insecure --data @RMRequestData_$en.xml www.wellpoint.com > report_RMRequestData_$en.txt

cat report_RMRequestData_$en.txt

results=$(cat report_RMRequestData_$en.txt|grep RMTableUpdateStatus |cut -d: -f1|cut -d">" -f2|xargs)

echo "Result from ReleaseManagement api call is :$result"

if [[$result != "Success"]];then echo "ReleaseManagement api call failed";exit 3; fi

#reportpath_name=$(cat report_RMRequestData_$en.txt |grep RMTableUpdateStatus|cut -d "=" -f2 |cut -d "<" -f1 |cut -d- -f2|xargs)


reportpath_name="/local_home/srcwgspg/DevOps/Report/${build}/ReleaseNotes_$en.xls"

echo "Report & its path:$reportpath_name"

#if [[-z $reportpath_name]]; then echo "Could not get Report path name. Exiting Now"; exit 3; fi

report_path=$(dirname $reportpath_name)
report_name=$(basename $reportpath_name)

#if [[ $? -ne 0 ]]; then echo "Error in Secure copy of Post Deployment Report."; exit 3; fi

#ssh srcwgspg@va33.wellpoint.com sudo /bin/chown -R srcwgspg /apps/pegashared/other_apps/

#Copy Release Notes Report in working directory to Define artifact
mkdir -p ReleaseNotesReport/Build_${build}

cd ReleaseNotesReport/Build_${build}
#rsync -avzhe ssh srcwgspg@va33.wellpoint.com:/apps/pegashared/other_apps/DevOps/Reports/ReleaseNotes_${en}.xls .
sftp srcwgspg@va33.wellpoint.com <<EOF
cd /apps/DevOps/Reports/
get ReleaseNotes_${en}.xls
exit
EOF

#mkdir -p /local_home/srcwgspg/DevOps/Reports/Build_${build}/

#cp -p ReleaseNotes_${en}.xls /local_home/srcwgspg/DevOps/Report/Build_${build}

#Reset RMRequest XML

cp $basermfile /apps/DevOps/Request/RMRequestData_$en.xml
cat /apps/DevOps/Request/RMRequestData_$en.xml
