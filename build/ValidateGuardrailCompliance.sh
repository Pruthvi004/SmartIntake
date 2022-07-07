#Check for Guardrail Compliance score
echo "########################## start check for Guardrail compliance score"

BBWD=$1

mkdir $BBWD/PegaHealthCheckReport
ValidationInfo_txt=$BBWD/PegaHealthCheckReport/ValidationInfo.txt

############################check for presence of ValidationInfo.txt file ###############
if [[-f "$ValidationInfo_txt"]]; then
   echo "Build failed because of following reason:";
   cat $ValidationInfo_txt;
   #exit 3;
fi