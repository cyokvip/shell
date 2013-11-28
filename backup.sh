#!/bin/sh
 
show_usage() {
    echo "Usage: backup.sh src_folder bak_folder bak_date"
    echo ""
    echo "src_folder - source folder to backup"
    echo "bak_folder - backup folder"
    echo "bak_date   - backup date in YYYYMMDD format"
}
 
 
if [ $# -ne 3 ]; then
    show_usage
    exit 1
fi
 
src_folder="$1"
bak_folder="$2"
bak_date="$3"
 
bak_file="$bak_folder/${bak_date}_backup.tar" # 这里把备份文件名固定为backup.tar了，你可以根据需要做些修改
if [ -f $bak_file ]; then
    rm $bak_file
fi
 
tmpfile="`mktemp`"
touch -t ${bak_date}0000 $tmpfile
cd $src_folder

find . -name "*.php" -maxdepth 1 -newer $tmpfile -exec tar rvf $bak_file {} \;
find ./application ! -name "PConfig.php" -regex '.*\.php\|.*\.css\|.*\.html\|.*\.jpg\|.*\.png\|.*\.gif' -newer $tmpfile -exec tar rvf $bak_file {} \;
find ./public ! -name "PConfig.php" -regex '.*\.php\|.*\.css\|.*\.html\|.*\.jpg\|.*\.png\|.*\.gif' -newer $tmpfile -exec tar rvf $bak_file {} \;
find ./Weidongman ! -name "PConfig.php" -regex '.*\.php\|.*\.css\|.*\.html\|.*\.jpg\|.*\.png\|.*\.gif' -newer $tmpfile -exec tar rvf $bak_file {} \;
find ./sdk ! -name "PConfig.php" -regex '.*\.php\|.*\.css\|.*\.html\|.*\.jpg\|.*\.png\|.*\.gif' -newer $tmpfile -exec tar rvf $bak_file {} \;
find ./lib ! -name "PConfig.php" -regex '.*\.php\|.*\.css\|.*\.html\|.*\.jpg\|.*\.png\|.*\.gif' -newer $tmpfile -exec tar rvf $bak_file {} \;
find ./libW ! -name "PConfig.php" -regex '.*\.php\|.*\.css\|.*\.html\|.*\.jpg\|.*\.png\|.*\.gif' -newer $tmpfile -exec tar rvf $bak_file {} \;


rm $tmpfile
echo "backup file: $bak_file"
ls -l $bak_file
