buildNumber=$1
planName=$2
BBWD=$3

HandleVersion_Info_txt=$BBWD/report_HandleVersion.txt
result=$(cat $HandleVersion_Info_txt|grep HandleVersionStatus| cut -d ">" -f2 |cut -d "<" -f1)

FROM=
TO=
CC=
SUBJECT=
ATTACH="$BBWD/report_HandleVersion.txt"

body="Team,
 Build Plan: ${planName}
 Build Number: ${buildNumber}
 Failed Reason : ${result}

 Please refer to the attached document for UnlockRuleSet API Response

 Thank You for using EagleEye DevOps

 EagleEye Team
 "

 mail -s "$SUBJECT " -r "$FROM" -c $CC "$ATTACH" "$TO" <<< "$body"