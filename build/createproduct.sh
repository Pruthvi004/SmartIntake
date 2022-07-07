BuildNum=$1
ENV=$2
inskey=$3
BBWD=$4

utilsfloder=$BBWD/prpcServiceUtils_84/prpcServiceUtils/scripts/utils/
agentDevOpsFloderPath=/app/DevOps
devDevOpsFloderPath=/app/DevOps
product_path="$BBWD/Products"

echo $inskey

cd $utilsfloder/FinalProduct/
ls -al $utilsfloder/FinalProduct/
product_name=$(basename *.zip)
echo "productname" $product_name

cd $BBWD
mkdir -p Products/Build_${BuildNum}

##Copy Product in working directory to Define artifact
cp $utilsfloder/FinalProduct/$product_name $product_path/Build_${BuildNum}

product_path_new=${product_path}/Build_${BuildNum}
productpath_name_new=${product_path_new}/${product_name}

#Save Product INS Key into Build <BuildNumber> Directory with  product artifactory
echo "inskey= '"$inskey"'">${product_path_new}/product_ins_key.txt

