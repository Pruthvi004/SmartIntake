env=$1
buildNumber=$2
planName=$3
BBWD=$4

reportpath_name= "$BBWD/PostDeploymentReport/Build_${buildNumber}/CompareResult*.xlsx"
echo "Report & its Path: $reportpath_name"
report_path=(dirname $reportpath_name)
report_name=(basename $reportpath_name)
echo "Report name is :$report_name"

Deployment_Info_txt =$BBWD/Deployment_Info.txt
bodymessage=$(cat $Deployment_Info_txt)
echo "Message to be sent is $bodymessage"

FROM=
TO=
CC=
SUBJECT=
ATTACH=

body ="Team
Build Plan: ${planName}
Build Number: ${buildNumber}

$bodymessage

Thank you for using Eagle Eye Devops

Eagle Eye Devops Team\

"

mail -s "$SUBJECT" -r "$FROM" -c $CC -a "$ATTACH " "$TO" <<< "$body
"