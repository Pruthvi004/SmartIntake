#Copy build variable file to current working directory
#pipeline=$1
buildKey=$1
app=$2
bwd=$(pwd)

agentDevopsFloderPath=/apps/DevOps
devDevOpsFloderPath=/apps/DevOps

echo "Copying Build Info to the Directory"
cp -v $agentDevopsFloderPath/ArtifactoryInfo/${app}KMBuild.info ${bwd}/
cp -v $agentDevopsFloderPath/ArtifactoryInfo/${app}KMBuild.info ${bwd}/KMBuild.info
