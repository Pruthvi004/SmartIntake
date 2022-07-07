env=$1
INSKEY=$2
BBWD=$3

utilsfloder=$BBWD/prpcServiceUtils_84/prpcServiceUtils/scripts/utils/
agentDevOpsFloderPath=/apps/DevOps
devDEvOpsFloderPath=/apps/DevOps

#Spilt the Product version and Product Name from inskey
product_name=$(echo$I | cut -f2 -d ' ')
product_version=$(echo $INSKEY |cut -f3 -d '')
restorepoint_label='Custom RP for import:'$product_name'' at $(date + '')

echo "Product name is :"$product_name
echo "Product version is :"$product_version
echo "Restore point label is :"$restorepoint_label

#Update the restore point label
sed -i "s/(manageRestorePoints\.restorePointLabel=\).*\$\1${restorepoint_label}/" $utilsfloder/${env}_prpcServiceUtils.properties
updaterestorepoint_label=$(grep ^manageRestorePoints.restorePointLabel $utilsfloder/${ebv}_prpcServiceUtils.properties |cut -d =-f2)

echo "Updated Restore Point Label is : $updaterestorepoint_label"

#set the manageRestorePoints action "Create"

restore_action=create
sed -i -e '/manageRestorepoints.action=/ s|=.*|='$restore_action '|' $utilsfloder/${env}_prpcServiceUtils.properties
updatedrestorepoint_action=$(grep ^manageRestorePoints.action $utilsfloder/${env}_prpcServiceUtils.properties |cut -d=-f2)

echo "Updated Restore actionis $updatedrestorepoint_action"

#Run commamd manageRestorePoints to create restore point
cd $utilsfloder
$utilsfloder/${env}_prpcServiceUtis.sh manageRestorePints