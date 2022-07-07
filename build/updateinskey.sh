ENV=$1
INSKEY=$2
BBWD=$3
utilsfloder=$BBWD/prpcServiceUtils_84/prpcServiceUtils/scripts/utils/

DateValue=$(date "")

#Spilt the Product Version and Product Name for Inskey
product_name=$(echo $INSKEY |cut -f2 -d ' ')
product_version=$(echo $INSKEY | cut -f3 -d  ' ')
archive_name=$product_name"_"$DateValue

echo "Product path is :"$archive_path
echo "Product name is: "$product_name
echo "Product Version is:"$product_version


sed -i -e '/export.archiveName=/ s|=.* |='$archive_name' | '$utilsfloder/DEV-prpcServiceUtils.properties
archive_path_new= $(grep ^export.archivename $utilsfloder/DEV_prpcServiceUtils.properties |cut -d= -f2)

sed -i -e '/export.productName=/ s|=.* |='$product_name' | '$utilsfloder/DEV-prpcServiceUtils.properties
archive_path_new= $(grep ^export.productName $utilsfloder/DEV_prpcServiceUtils.properties |cut -d= -f2)

sed -i -e '/export.productName=/ s|=.* |='$product_version' | '$utilsfloder/DEV-prpcServiceUtils.properties
archive_path_new= $(grep ^export.productVersion $utilsfloder/DEV_prpcServiceUtils.properties |cut -d= -f2)

echo "Product path is :"$archive_path_new
echo "Product name is: "$product_name_new
echo "Product Version is:"$product_version_new