#!/bin/bash
GLOBIGNORE=".:.."
WORKING_DIR=$(pwd)

cd $WORKING_DIR

PSALM_BIN=$WORKING_DIR/../psalm/psalm

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

    if [[ $project == *"zendframework1"* ]]
    then
        continue 
    fi

    summary_path=$project/psalm-summary.json

    if [ -f $summary_path ]; then
        continue
    fi

    echo $project
    cd $project
    composer install --no-dev --ignore-platform-reqs
    $PSALM_BIN --init
    $PSALM_BIN --no-cache --find-dead-code --show-info=false --threads=6 --report=psalm-summary.json
    cd $WORKING_DIR
done