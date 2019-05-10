#!/bin/bash
GLOBIGNORE=".:.."
WORKING_DIR=$(pwd)

cd $WORKING_DIR

for zip in zipballs/*/*.zip; do
    target=${zip/zipballs/sources}
    target=${target/.zip/}
    echo $target
    if [ -d $target ]; then
        continue
    fi

    echo "Extracting..."
    mkdir -p $target
    unzip -qq $zip -d $target
    subdir=($target/*)
    mv $subdir/* $target
    rmdir $subdir
done

for project in sources/*/*; do
    if [[ $project == *"polyfill"* ]]
    then
        continue 
    fi

    if [[ $project == *"laravel-aws-worker"* ]]
    then
        continue 
    fi

    if [[ $project == *"phpmailer"* ]]
    then
        continue 
    fi

    if [[ $project == *"mpdf"* ]]
    then
        continue 
    fi

    echo $project
    cd $project
    composer install --no-dev
    $WORKING_DIR/../psalm/psalm --init
    $WORKING_DIR/../psalm/psalm --no-cache --show-info=false
    cd $WORKING_DIR
done