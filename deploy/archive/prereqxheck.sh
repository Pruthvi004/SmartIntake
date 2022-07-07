## Check Version format

ENV=$1
BUILDVERSION=$2
PIPELINE=$3

##Check Version Format

if [[$BUILDVERSION == [0-9]]];then echo "Version suppiled is $BUILDVERSION"; else echo "Please follow the version format (For instance BUILDVERSION=<Build_Number of bamboo>)"; exit 3; fi

if [ "{$PIPELINE}"= "Major" ]
then 
    bamboo_Artifactory="Build_${BUILDVERSION}"
    echo "Deploying from Major Pipeline Build (bamboo.anthem.com)"
elif [ "{$PIPELINE}"= "Minor" ]
then 
    bamboo_Artifactory="Minor/Build_${BUILDVERSION}"
    echo "Deploying from Minor Pipeline Build (bamboo.anthem.com)"
elif [ "{$PIPELINE}"= "EandB" ]
then 
    bamboo_Artifactory="EaandB/Build_${BUILDVERSION}"
    echo "Deploying from EandB Pipeline Build (bamboo.anthem.com)"
elif [ "{$PIPELINE}"= "OffCycle" ]
then 
    bamboo_Artifactory="OffCycle/Build_${BUILDVERSION}"
    echo "Deploying from OffCycle Pipeline Build (bamboo.anthem.com)"
else
    echo "Please follow the pipeline choice format.Option are Major , Minor, Offcycle or EandB"
    exit 3
fi

#remove previous file
rm /local_hone/srcwgsp/DevOps/ArtifactoryInfo/Artifact_${ENV}.ArtifactoryInfo
#set Artifactory Path
echo "Artifactory =" ${bamboo_Artifactory} >> /local_hone/srcwgsp/DevOps/ArtifactoryInfo/Artifact_${ENV}.info
