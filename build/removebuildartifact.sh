#Removes the jar file after it has been sent to artifactory
buildNum=$1
BBWD=$2

agentDevOpsFloderPath=/apps/DevOps
devDevOpsFloderPath=/apps/DevOps

rm -rf $BBWD/prpcServiceUtils_84/prpcServiceUtils/scripts/utils/FinalProduct/*
rm -rf $agentDevOpsFloderPath/prpcServiceUtils_84/scripts/utils/FinalProduct/*
rm -rf $BBWD/Products/*
rm -rf $agentDevOpsFloderPath/Products/*
