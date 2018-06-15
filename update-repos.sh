root=/mnt/storage/archives/repos

for dir in $root/*/
do
    dir=${dir%*/}
    cd ${root}/${dir##*/}
    git pull origin master 
done

