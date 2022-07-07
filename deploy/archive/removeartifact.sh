#REmoves the jar file after it has been sent to artifactory
buildNumber=$1
BBWD=$2

agentDevOpsFloderPath=/apps/DevOps
agentDevOpsFloderPath=/apps/DevOps

rm -rf $agentDevOpsFloderPath/Products/Build_${buildNumber}
rm -rf $BBWD/Products/Build_${buildNumber}
