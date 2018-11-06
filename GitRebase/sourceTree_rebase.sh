
echo "当前目录:"
pwd

BranchName=$(git symbolic-ref --short -q HEAD)
echo "当前分支:"
echo $BranchName

git pull origin $BranchName --rebase
