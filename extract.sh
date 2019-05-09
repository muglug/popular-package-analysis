#!/bin/bash
set -e
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
    unzip $zip -d $target
    subdir=($target/*)
    mv $subdir/* $target
    rmdir $subdir
done

for project in sources/*/*; do
    echo $project
    cd $project
    composer install
    $WORKING_DIR/../psalm/psalm --init
    cd $WORKING_DIR
done

for project in sources/*/*; do
    echo $project
    cd $project
    $WORKING_DIR/../psalm/psalm --show-info=false
    cd $WORKING_DIR
done