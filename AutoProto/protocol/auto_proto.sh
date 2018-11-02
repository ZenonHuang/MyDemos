#!/bin/bash

if [ ! -n "$1" ] ;then
echo "--- ❌ 分支名没有输入，需要重传 ----"
echo "示例: auto_proto.sh develop"
exit
else
echo "--- 分支名为: ${Branch},没有则需要重传 ----"
fi

Branch=$1

RepoPath=ssh://xxx.git

#1. clone proto 仓库,并做清理
rm -rf protoRepo
git clone $RepoPath protoRepo

#2. checkout 需要的分支
cd  protoRepo
git checkout -b ${Branch} origin/${Branch}
cd  ../

#3. 移动需要的文件
echo "移动 pb 文件"
mkdir client
mkdir pb
#记得确定一下仓库存放pb文件路径
mv  ./protoRepo/src/main/proto/client/* ./client
mv  ./protoRepo/src/main/proto/pb/* ./pb
echo "移动完成"

#4. 专成 OC 文件输出
GEN_DIR=../protoOC
echo "开始输出OC文件: ${GEN_DIR}"

#pb
rm -rf GEN_DIR/pb
for file in `ls ./pb`
do
#.ext.proto
if [[ `echo $file | awk -F'.' '$0~/.*ext.*proto/{print $3}'` = "proto" ]]
then
echo "name: ${file} ${GEN_DIR}/pb"
./protoc --objc_out=${GEN_DIR} \
pb/$file
fi
done

#client
rm -rf $GEN_DIR/client
for file in `ls ./client`
do
#.proto
if [[ `echo $file | awk -F'.' '$0~/.*proto/{print $2}'` = "proto" ]]
then
echo "name: ${file} ${GEN_DIR}/client"
./protoc --objc_out=${GEN_DIR} \
client/$file
fi
done

echo "输出完成"

#清理Repo
rm -rf protoRepo
