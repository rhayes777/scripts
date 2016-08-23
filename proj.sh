#!/bin/bash

function update_config {
    sed "s/\($1 *= *\).*/\1$2/" ~/projects/$3/conf > temp
    mv temp ~/projects/$3/conf
}

source ~/projects/.state

if [[ -f "$HOME/projects/$name/conf" ]]; then
    source ~/projects/$name/conf
fi

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
                        echo "name=$name" > ~/projects/.state
                        root=~/projects/$name
                        mkdir $root
                        cp ~/scripts/res/gitignore $root/.gitignore
                        cp ~/scripts/res/conf $root/
                        cp ~/scripts/res/proj $root/
                        cd $root
                        open proj
                        git init
                        git add .gitignore
                        git add *
                        git commit -m "initial commit"
                        break
                        ;;
                install)
                        cd $root
                        git commit -am "before installation"
                        file="proj"
                        while read -r line; do
                            [[ "$line" =~ ^#.*$ ]] && continue
                            case "$line" in 
                                        ios)    
                                                if [ ! -d "$root/ios" ]; then
                                                    mkdir $root/ios
                                                fi
                                                continue
                                                ;;
                                        android)
                                                if [ ! -d "$root/android" ]; then
                                                    mkdir $root/android
                                                fi
                                                continue
                                                ;;
                                        python)
                                                if [ ! -d "$root/python" ]; then
                                                    mkdir $root/python
                                                    mkdir $root/python/$name
                                                    virtualenv $root/python
                                                    cp ~/scripts/res/database.py $root/python/$name
                                                fi
                                                continue
                                                ;;
                                        ionic)
                                                if [ ! -d "$root/ionic" ]; then
                                                    mkdir $root/ionic
                                                fi
                                                continue
                                                ;;
                                        postgres)
                                                unset PGPASSWORD
                                                psql -U postgres -d postgres -c "create user $name with password '$name';"
                                                psql -U postgres -d postgres -c "create database $name with owner $name;"
                                                update_config DATABASE_NAME $name $name
                                                update_config DATABASE_USER $name $name
                                                update_config DATABASE_PASSWORD $name $name
                                                continue
                                                ;;
                                        spec)
                                                if [ ! -d "mkdir $root/spec" ]; then
                                                    mkdir $root/spec
                                                fi
                                                continue
                                                ;;
                                        requirements)
                                                if [ ! -d "mkdir $root/requirements" ]; then
                                                    mkdir $root/requirements
                                                fi
                                                continue
                                                ;;
                                        resources)
                                                if [ ! -d "mkdir $root/resources" ]; then
                                                    mkdir $root/resources
                                                fi
                                                continue
                                                ;;
                            esac
                        done < "$file"
                        git add *
                        git commit -m "after installation"
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
                prun)
                        go ~/projects/$name/python/$name
                        . bin/activate &>/dev/null; . ../bin/activate &>/dev/null
                        python ../__init__.py
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
                rp)
                        ssh $PROD_SERVER_USER@$PROD_SERVER_URL -p $PROD_SERVER_PORT 'touch $HOME/website/wsgi.py'
                        break
                        ;;
                sshdt)
                        ssh -L 9999:127.0.0.1:5432 $DEV_SERVER_USER@$DEV_SERVER_URL -p $DEV_SERVER_PORT
                        break
                        ;;
                sshpt)
                        ssh -L 9999:127.0.0.1:5432 $PROD_SERVER_USER@$PROD_SERVER_URL -p $PROD_SERVER_PORT
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

