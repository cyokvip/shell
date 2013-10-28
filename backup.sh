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
#不排除
#find . -name "*.php" -newer $tmpfile -exec tar rvf $bak_file {} \; 
#排除svn
#find . -path "./svn" -prune -o -name "*.php" -newer $tmpfile -exec tar rvf $bak_file {} \;
#排除多个目录
#find . \( -path "./svn" -o -path "./admin.php" -o -path "./index.php" -o -path "./mc.php" -o -path "./tq.config.inc.php" -o -path "./mcAssets" -o -path "./mcImages" -o -path "./mcSounds" -o -path "./mcThumbs" -o -path "./mcThumbsB" \) -prune -o -name "*.php" -newer $tmpfile -exec tar rvf $bak_file {} \;
#正则查找指定匹配并且排除指定文件
find . ! -name "PConfig.php" -regex '.*\.php\|.*\.css' -newer $tmpfile -exec tar rvf $bak_file {} \;
rm $tmpfile
 
echo "backup file: $bak_file"
ls -l $bak_file
