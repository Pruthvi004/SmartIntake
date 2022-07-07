env=$1
buildNumber=$2
BBWD=$3

utilsfloder=$BBWD/prpcServiceUtils_84/prpcServiceUtils/scripts/utils/
agentDevOpsFloderPath=/apps/DevOps
devDevOpsFloderPath=/apps/DevOps

mkdir /apps/DevOps/temp
chmod 777 /apps/DevOps/temp
chmod 777 /apps/DevOps/temp/*

echo "copying the files to local floder"

#cp -p $(pwd)/prpcServiceUtils_84/prpcServiceUtils/scripts/utils/* /apps/pegashared/other_apps/DevOps/PRPCServiceUtils_84/prpcServiceUtils_84/scripts/utils/

#chmod 0777 /apps/pegashared/other_apps/DevOps/PRPCServiceUtils_84/prpcServiceUtils/scripts/utils/*

product_path_new=$BBWD/Products/Build_$buildNumber
product_name=$(ls -ltr $product_path_new/*.zip|tail -1|awk '{print $9}')

echo $product_path_new
echo $product_name
product_path_new=$(basename $product_name)

if [[ -z $product_path_new ]]; then echo "Could not get the product name .Exiting now."; exit 3; fi
productpath_name_new=${product_path_new}/${product_name_new}

sed -i -e '/import.archive.path=/s|=.*|='$productpath_name_new '|' $utilsfloder/${env}_prpcServiceUtils.properties
archive_path=$(grep ^import.archive.path $utilsfloder/${env}_prpcServiceUtils.properties | cut -d' ' -f2)

echo "Archive path: $archive_path"

if [[-z $archive_path ]]; then echo "Could not get the archive path.Exiting now.";exit 3; fi
