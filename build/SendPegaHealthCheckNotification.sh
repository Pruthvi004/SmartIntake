BBWD=$1
buildNum=$2
planName=$3
RELEASE=$4
env=$5

pegahealthcheckdir=$BBWD/PegaHealthCheckReport
ValidationInfo_txt=$pegahealthcheckdir/ValidationInfo.txt
Info_Product_txt=$pegahealthcheckdir/GuardrailsOnProductInfo.txt
Info_txt=$pegahealthcheckdir/GuardrailsInfo.txt
PegaUnitInfo_txt=$pegahealthcheckdir/PegaUnitInfo.txt

bodymessage=$(cat $ValidationInfo_txt)

echo "Message body is :$bodymessage"

SUBJECT="DevOps Health Check Report - PegaKM $env - ${RELEASE} Build : ${buildNum}"
FROM=
TO=
CC=
body="Team

Build Plan : ${planName}
Build Number: ${buildNum}
$bodymessage

NOTE: Guardrail Compliance Score must be at 90 or above in order to pass PERF enviornment and approved for PROD release.For additional information on Guardrails health please refer to attched documents.

Thanks for Using Eagle Eye Devops

EagleEye Team  
"

if [[-f "$ValidationInfo_txt"]]; then

#Find the total no of reports
cd $pegahealthcheckdir
echo -e "\nCurrent Working Directory"
pwd

TotalReports=$(find . -type f -name '*.xls*'|wc -1)
echo -e "\nTotal no of reports="$TotalReports

#Files name
echo -e "/nReports to be sent ="
ls -al |grep '.xls'| awk '{print $9}'

if [["$TotalReportd" -ge "1"]]; then 
   for i in $(ls-al |grep '.xls' |awk '{print $9)';do
   attlogs+=("-a" "$i")
   done
   if [[-f "$Info_Product_txt"]]; then attlogs+=("-a" "$Info_Product_txt"); echo "$Info_Product_txt exits"; fi
   if [[-f "$Info_txt]]; then attlogs+=("-a " "$Info_txt"); echo "$Infp_txt exits."; fi
   if [["-f "$PegaUnitInfo_txt"]]; then attlogs+=("-a" "$Info_txt"); echo "$Info_txt exits." :fi
mail -s "$SUBJECT" -r "$FROM" -c "$CC" "${attlogs[@]}" "$TO" <<<"$body"
fi
  if ["$env" !="DEV"]; then 
  mail -s "$SUBJECT" -r "$FROM" -c $CC "$TO" <<< "$body"
  fi
fi

#test
