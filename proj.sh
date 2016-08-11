#!/bin/bash

function update_config {
    sed "s/\($1 *= *\).*/\1$2/" ~/projects/$3/conf > temp
    mv temp ~/projects/$3/conf
}

source ~/projects/.state
source ~/projects/$name/conf

root=~/projects/$name

if [ $# -eq 0 ]; then
    cd ~/projects/$name
    clear;pwd;ls
    git status
fi

while test $# -gt 0; do
        case "$1" in
                init)
                        name=$2
                        root=~/projects/$name
                        mkdir $root
                        break
                        ;;
                install)
                        break
                        ;;
                -n|--new)
                        mkdir $root/spec
                        mkdir $root/ios
                        mkdir $root/android
                        mkdir $root/python
                        mkdir $root/python/$name
                        virtualenv $root/python
                        echo "name=$name" > ~/projects/.state
                        cp ~/scripts/res/gitignore $root/.gitignore
                        cp ~/scripts/res/conf $root/conf
                        cp ~/scripts/res/database.py $root/python/$name
                        cd $root
                        unset PGPASSWORD
                        psql -U postgres -d postgres -c "create user $name with password '$name';"
                        psql -U postgres -d postgres -c "create database $name with owner $name;"
                        update_config DATABASE_NAME $name $name
                        update_config DATABASE_USER $name $name
                        update_config DATABASE_PASSWORD $name $name
                        git init
                        git add .gitignore
                        git add *
                        git commit -m "initial commit"
                        break
                        ;;
                -s|--switch)
                        name=$2
                        cd ~/projects/$name
                        clear;pwd;ls
                        git status
                        echo "name=$name" > ~/projects/.state
                        break
                        ;;
                a|android)
                        go ~/projects/$name/android/$name
                        break
                        ;;
                as)
                        go ~/projects/$name/android/$name
                        open -a /Applications/Android\ Studio.app .
                        break
                        ;;
                i|ios)
                        go ~/projects/$name/ios/$name
                        break
                        ;;
                xc)
                        go ~/projects/$name/ios/$name
                        open *.xcworkspace
                        break
                        ;;
                p|python)
                        go ~/projects/$name/python/$name
                        . bin/activate &>/dev/null; . ../bin/activate &>/dev/null
                        break
                        ;;
                s|spec)
                        go ~/projects/$name/spec
                        break
                        ;;
                q|qgis)
                        go ~/projects/$name/qgis
                        break
                        ;;
                r|resources)
                        go ~/projects/$name/resources
                        break
                        ;;
                --state|state)
                        echo $name
                        break
                        ;;
                db)
                        export PGPASSWORD=$DATABASE_PASSWORD; psql -U $DATABASE_USER -d $DATABASE_NAME -h localhost -p 5432
                        break
                        ;;
                sshd)
                        ssh $DEV_SERVER_USER@$DEV_SERVER_URL -p $DEV_SERVER_PORT
                        break
                        ;;
                sshp)
                        ssh $PROD_SERVER_USER@$PROD_SERVER_URL -p $PROD_SERVER_PORT
                        break
                        ;;
                syncd)
                        rsync -e ssh -a $root/python/$name/ $DEV_SERVER_USER@$DEV_SERVER_URL:$DEV_SERVER_PATH/$name/
                        ssh $DEV_SERVER_USER@$DEV_SERVER_URL '. ~/$DEV_SERVER_PATH/$name/apache2/bin/restart'
                        break
                        ;;
                syncp)
                        rsync -e ssh -a $root/python/$name/ $PROD_SERVER_USER@$PROD_SERVER_URL:$PROD_SERVER_PATH/$name/
                        ssh $PROD_SERVER_USER@$PROD_SERVER_URL 'touch ~/$PROD_SERVER_PATH/wsgi.py'
                        break
                        ;;
                dev)
                        update_config ROOT_URL $DEV_SERVER_URL/$name $name
                        break
                        ;;
                prod)
                        update_config ROOT_URL $PROD_SERVER_URL/$name $name
                        break
                        ;;
                pc)
                        charm ~/projects/$name/python &
                        break
                        ;;
                -r)     
                        convert $2 -resize 100% ~/projects/$name/android/$name/app/src/main/res/drawable-xxxhdpi/$2
                        convert $2 -resize 75% ~/projects/$name/android/$name/app/src/main/res/drawable-xxhdpi/$2
                        convert $2 -resize 50% ~/projects/$name/android/$name/app/src/main/res/drawable-xhdpi/$2
                        convert $2 -resize 33% ~/projects/$name/android/$name/app/src/main/res/drawable-hdpi/$2
                        convert $2 -resize 17% ~/projects/$name/android/$name/app/src/main/res/drawable-mdpi/$2
                        fileroot=${2%.*}
                        ios_path="$HOME/projects/$name/ios/$name/$name/Assets.xcassets/$fileroot.imageset"
                        mkdir $ios_path
                        echo '{"images" : [{"idiom" : "universal", "filename" : "'$fileroot'.png", "scale" : "1x"    },    {      "idiom" : "universal",      "filename" : "'$fileroot'@2x.png",      "scale" : "2x"    },    {      "idiom" : "universal",      "filename" : "'$fileroot'@3x.png",      "scale" : "3x"    }  ],  "info" : {    "version" : 1,    "author" : "xcode"  }}' > $ios_path"/Contents.json"
                        convert $2 -resize 100% $ios_path"/$fileroot@3x.png"
                        convert $2 -resize 66% $ios_path"/$fileroot@2x.png"
                        convert $2 -resize 33% $ios_path"/$fileroot.png"
                        shift
                        break
                        ;;
                *)
                        break
                        ;;
                
        esac
done
