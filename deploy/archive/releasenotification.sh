en=$1
buildNumber=$2
planName=$3
BBWD=$4

FROM=
TO=
CC=
SUBJECT=
ATTACH=
MAILPART="==".$(date +%Y-%m-%d). "===" #Generates Unique ID
(
echo "From: $FROM"
echo "To: $TO"
echo "CC: $CC"
echo "Subject:$SUBJECT"
echo "MIME-Version:1.0"
echo "Content-Type: multipart/mixed;boundary=\"$MAILPART\""
echo ""
echo "--$MAILPART"
echo "Content-Type: text/html"
echo "Content-Disposition: inline"
echo ""
echo "Team"
echo "<br>"
echo "<br>"
echo "Build Plan : ${planName}"
echo "Build Number : ${buildNumber"
echo "<br>"
echo "<br>"
echo "Please refer to the attached documentation for Release Notes"
echo "<br>"
echo "<br>"
echo "<br>"
echo "Thanks for using EagleEye DevOps"
echo "<br>"
echo ""
echo "Content-Type: application/vnd.ms-excel"
echo "Content-Disposition: attachment;filename=\"$(basename $ATTACH)\"'
echo "'
cat $ATTACH
echo ""
echo "--$MAILPART--"

)| sendmail -t
