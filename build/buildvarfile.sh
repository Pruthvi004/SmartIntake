buildNumber=$1
inskey=$2
app=$3

agentDevOpsFloderPath=/app/agentDevOpsFloderPath
devDevOpsFloderPath=/app/devDevOpsFloderPath

#Removing previous file 
mkdir $agentDevOpsFloderPath/ArtifactoryInfo
rm $agentDevOpsFloderPath/ArtifactoryInfo/${app}KMBuild.ArtifactoryInfo

#Sorting new build info
echo "BuildNumber =" ${buildNumber} >> $agentDevOpsFloderPath/ArtifactoryInfo/${app}KMBuild.info
