env=$1
RestorePoint=$2
BBWD=$3
bwd=$(pwd)

#rsync -rtvp ${bwd}/* /apps/pegashared/other_apps/Pega731/scripts/deploy
#chmod -R 0777 /apps/pegashared/other_apps/Pega731/scripts

utilsfloder=$BBWD/prpcServiceUtils_84/prpcServiceUtils/scripts/utils/
agentDevOpsFloderPath=/apps/DevOps
devDevOpsFloderPath=/apps/DevOps

echo "Enviornment for Rollback is $ENV"
echo "Restore Point Name is $ResorePoint"

if [[-z $RestorePoint]]; then echo "There is no Restore Point Name. Exiting Now.";exit 3; fi
if [[-z $env]]; then echo "There is no Environment for Restore Point.Exiting Now.";exit 3; fi

echo "Before Upating the ${env}_prpcServiceutils.properties"

sed -i -e '/rollback.restorePointName=/ s|=.*|='$ResorePoint'|'$utilsfloder/${env}_prpcServiceutils.properties
ResorePoint_Path=$(grep ^rollback.restorePointName $utilsfloder/${env}_prpcServiceutils.properties|cut -d =-f2)

echo "Rollback Restore Point Path is : $ResorePoint_Path"

if [[-z $ResorePoint_Path]]; then echo "Could not get the Restore Point Path.Exiting Now."; exit 1; fi

#set the managementstorePoint name

sed -i -e '/manageRestorePoint.restorePointName=/ s|=.*|='$RestorePoint'|'$utilsfloder/${env}_prpcServiceutils.properties
updatedrestorepoint_name=$(grep ^manageRestorePoint.restorePointName $utilsfloder/${env}_prpcServiceutils.properties |cut -d= -f2)

echo "Updated Restore Point name is: $updatedrestorepoint_name"

#set the manageRestorePoint action "get"

restore_action=get
sed -i -e '/manageRestorePoint.action=/ s|=.*|='$restore_action'|' $utilsfloder/${env}_prpcServiceutils.properties
updatedrestorepoint_action =$(grep ^manageRestorePoint.action $utilsfloder/${env}_prpcServiceutils.properties| cut -d= -f2)

echo "Updated Restore action is :$updatedrestorepoint_action"
 

 