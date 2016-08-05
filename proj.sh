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
                -n|--new)
                        name=$2
                        root=~/projects/$name
                        mkdir $root
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
                        open -a /Applications/Android\ Studio.app .
                        break
                        ;;
                i|ios)
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
                *)
                        break
                        ;;
                
        esac
done
