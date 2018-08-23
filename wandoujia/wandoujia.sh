#!/usr/bin/env bash
count=
categoryId=
page=
MD5=
totalCount=
pageNum=
hasRemainder=0
getSign(){
	sign=secret.wdj.clientcategoryId=${categoryId}count=${count}flags=193order=4page=${page}resourceType=0subCategoryId=0LVJd97AbRtikeYRRhi3ocdwSD
	MD5=`echo -n $sign | md5sum | awk '{print $1'}`
}

getTotalCount(){
	echo "getTotalCount!"
	categoryId=$1
	count=1
	page=1
	getSign
	totalCount=`curl -sX $'POST' -H $'Host: w.api.pp.cn' --data-binary $"{\"client\":{\"caller\":\"secret.wdj.client\",\"ex\":{\"osVersion\":23}},\"data\":{\"count\":$count,\"order\":4,\"flags\":193,\"subCategoryId\":0,\"resourceType\":0,\"page\":$page,\"categoryId\":$categoryId},\"sign\":\"$MD5\",\"encrypt\":\"md5\"}" $'http://w.api.pp.cn/api/resource.app.getList' | jq '.data.totalCount'`
}

getPageNum(){
	echo "getPageNum!"
	count=100
	remainder=$((totalCount%count))
	quotient=$((totalCount/count))
	if [[ $remainder -eq 0 ]]; then
		pageNum=$quotient
	else
		pageNum=$quotient
		hasRemainder=$remainder
	fi
}

getApkInfo(){
	echo "getApkInfo!"
	getSign
	curl -sX $'POST' -H $'Host: w.api.pp.cn' --data-binary $"{\"client\":{\"caller\":\"secret.wdj.client\",\"ex\":{\"osVersion\":23}},\"data\":{\"count\":$count,\"order\":4,\"flags\":193,\"subCategoryId\":0,\"resourceType\":0,\"page\":$page,\"categoryId\":$categoryId},\"sign\":\"$MD5\",\"encrypt\":\"md5\"}" $'http://w.api.pp.cn/api/resource.app.getList' | jq '.data.content' | sed '/downloadUrl/!d' | awk '{print $2}' | sed 's/"//gp' | sed 's/,//p' >> apkUrl

}

getReady(){
	echo "getReady!"
	categoryId=$1
	count=100
	if [[ hasRemainder -eq 0 ]]; then
		for i in `seq 1 $quotient`
		do
			page=$i
			getApkInfo
		done
	else
		for i in `seq 1 $quotient`
		do
			page=$i
			getApkInfo
		done
		page=$(($quotient+1))
		count=$remainder
		getApkInfo
	fi

}

touch apkUrl
for i  in `curl -s https://www.wandoujia.com/category/app | awk '/("cate-link")/{print}' | sed '$d' | grep -o "[0-9]*"`
do
	getTotalCount $i
	getPageNum
	getReady $i
	echo $i" finished!"
done





# getApkname
# curl -sX $'POST' -H $'Host: w.api.pp.cn' --data-binary $'{\"client\":{\"caller\":\"secret.wdj.client\",\"ex\":{\"osVersion\":23}},\"data\":{\"count\":10,\"order\":4,\"flags\":193,\"subCategoryId\":0,\"resourceType\":0,\"page\":1,\"categoryId\":5029},\"sign\":\"b6cbd2f675f70bcf3e3f3b5c9c49b9d1\",\"encrypt\":\"md5\"}' $'http://w.api.pp.cn/api/resource.app.getList' | jq '.data.content' | sed '/packageName/!d' | awk '{print $2}' | sed -n 's/"//gp' | sed -n 's/,/.apk/p'


# getDownloadUrl
# curl -sX $'POST' -H $'Host: w.api.pp.cn' --data-binary $'{\"client\":{\"caller\":\"secret.wdj.client\",\"ex\":{\"osVersion\":23}},\"data\":{\"count\":10,\"order\":4,\"flags\":193,\"subCategoryId\":0,\"resourceType\":0,\"page\":1,\"categoryId\":5029},\"sign\":\"b6cbd2f675f70bcf3e3f3b5c9c49b9d1\",\"encrypt\":\"md5\"}' $'http://w.api.pp.cn/api/resource.app.getList' | jq '.data.content' | sed '/downloadUrl/!d' | awk '{print $2}' | sed 's/"//gp' | sed 's/,//p'