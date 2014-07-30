#!/bin/bash

DOMAIN="yafowil"
SEACH_PATH=src/yafowil
LOCALES_PATH=src/yafowil/i18n/locales

# create locales folder if not exists
if [ ! -d "$LOCALES_PATH" ]; then
    echo "Locales directory not exists, create"
    mkdir -p $LOCALES_PATH
fi

# no arguments, extract and update
if [ $# -eq 0 ]; then
    echo "Extract messages"
    pot-create $SEACH_PATH -o $LOCALES_PATH/$DOMAIN.pot

    echo "Update translations"
    for po in $LOCALES_PATH/*/LC_MESSAGES/$DOMAIN.po; do
        msgmerge -o $po $po $LOCALES_PATH/$DOMAIN.pot
    done

    echo "Compile message catalogs"
    for po in $LOCALES_PATH/*/LC_MESSAGES/*.po; do
        msgfmt -o ${po%.*}.mo $po
    done

# first argument represents language identifier, create catalog
else
    cd $LOCALES_PATH
    mkdir -p $1/LC_MESSAGES
    msginit -i $DOMAIN.pot -o $1/LC_MESSAGES/$DOMAIN.po -l $1
fi
