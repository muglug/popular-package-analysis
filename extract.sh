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
    if [ -d "src" ]; then
        $WORKING_DIR/../psalm/psalm --init
    elif [ -d "lib" ]; then
        $WORKING_DIR/../psalm/psalm --init lib
    fi
    cd $WORKING_DIR
done

for project in sources/*/*; do
    echo $project
    cd $project
    set +e
    $WORKING_DIR/../psalm/psalm --show-info=false
    set -e
    cd $WORKING_DIR
done