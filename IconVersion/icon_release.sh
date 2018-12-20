#!/bin/sh

#项目 repo 目录
Workspace="/Users/XXX/your_project/"
# 工程名
APP_NAME="XXX"

#把 appIcon 的图片，复制到 AppIcon-Internal
icons_path="${Workspace}/${APP_NAME}/Assets.xcassets/AppIcon.appiconset"
icons_dest_path="${Workspace}/${APP_NAME}/Assets.xcassets/AppIcon-Internal.appiconset"

echo "icons_path: ${icons_path}"
echo "icons_dest_path: ${icons_dest_path}"

#1.清除原来 png 文件
find "${icons_dest_path}" -type f -name "*.png" -print0 |
while IFS= read -r -d '' file; do
echo "rm file $file"
rm -rf $file
done

#2. icons_path 复制到icons_dest_path
find "${icons_path}" -type f -name "*.png" -print0 |
while IFS= read -r -d '' file; do
echo "file: ${file}"
image_name=$(basename $file)
echo "copy image: ${image_name}"
cp $file ${icons_dest_path}/${image_name}
done



