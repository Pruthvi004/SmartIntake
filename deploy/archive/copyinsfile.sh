#Copies the INS Key File to the working directory
buildNumber=$1
BUILDKEY=$2
bwd=$(pwd)

echo "Copying the product ins key to the present working directory"

cp /apps/DevOps/Products/Build_${buildNumber}/product_ins_key.txt $(pwd)/
