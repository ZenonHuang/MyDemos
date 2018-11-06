#!/bin/bash

#1.获取输入文件 .ipa/.apk
if [ ! -n "$1" ] ;then
echo "--- ❌ 文件没有输入，需要输入 ----"
echo "示例: appmd5.sh XXX.ipa"
exit
else
echo "--- 文件名为 $1 ----"
fi

file_name=$1

echo "name: $file_name"

#2.对文件进行 md5 , 获取输出的 md5 值

md5result=`md5 ${file_name}`
echo $md5result >> appmd5.txt

echo "result $md5result"
