#!/bin/bash

DOWNLOADS="/storage/.xbmc/userdata/addon_data/script.nationwide_membernet/downloads"

update_margins()
{
    # units are 1k blocks, so GBs
    # less than LO_FREE triggers purge
    LO_FREE=$((50 * 1024*1024))
    # greater then HI_FREE ends purge
    HI_FREE=$((75 * 1024*1024))

    USED=`df /dev/sda2 | sed '1d' | awk '{print $3}'`
    SIZE=`df /dev/sda2 | sed '1d' | awk '{print $2}'`
    FREE=$(($SIZE - $USED))
    echo "free = $FREE, lo_trigger = $LO_FREE, hi_trigger = $HI_FREE"
}

# exit if downloads dir does not exist
if [ ! -d "${DOWNLOADS}" ]; then
    echo "$DOWNLOADS does not exist"
    exit 1
fi

while true; do
    sleep 2m
    echo "purge checking `date`"

    update_margins

    if [ ${FREE} -le ${LO_FREE} ]; then
        echo "starting purge, $FREE less than $LO_FREE"
        while true; do
        TARGET=$(ls -tud $(find ${DOWNLOADS} -type f) | tail -1)
        if [[ "$TARGET" == "" ]]; then
            echo "purge aborted, no files found"
            break;
        fi
        rm -f $TARGET
        update_margins
        echo "purge removed $TARGET, free space $FREE"
        if [ ${FREE} -ge ${HI_FREE} ]; then
            echo "purge complete, $FREE greater than $HI_FREE"
            break;
        fi
        done
    fi
done

exit 0

