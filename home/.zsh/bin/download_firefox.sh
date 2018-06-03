#!/bin/zsh

SHASUMS_ASC=http://releases.mozilla.org/pub/firefox/releases/VERSION/SHA512SUMS.asc
SHASUMS=http://releases.mozilla.org/pub/firefox/releases/VERSION/SHA512SUMS
FIREFOX_FILE_PATH=linux-x86_64/en-US/firefox-VERSION.tar.bz2
FIREFOX_URL=http://releases.mozilla.org/pub/firefox/releases/VERSION/$FIREFOX_FILE_PATH

function download_and_verify() {
    local version=$1
    local shasums_asc=$(echo $SHASUMS_ASC | sed "s/VERSION/$version/g")
    local shasums=$(echo $SHASUMS | sed "s/VERSION/$version/g")
    local firefox_file_path=$(echo $FIREFOX_FILE_PATH | sed "s/VERSION/$version/g")
    local firefox_url=$(echo $FIREFOX_URL | sed "s/VERSION/$version/g")
    local firefox_file=$(basename $firefox_file_path)

    echo $shasums
    echo "Downloading SHA512SUMS"
    [ -f SHA512SUMS ] && {
        echo "File SHA512SUMS does exist, replacing"
        rm -f SHA512SUMS
    }
    wget "$shasums" || {
        echo "Error downloading SHA512SUMS, aborting"
        exit 2
    }
    
    [ -f SHA512SUMS.asc ] && {
        echo "File SHA512SUMS.asc does exist, replacing"
        rm -f SHA512SUMS.asc
    }
    wget "$shasums_asc" || {
        echo "Error downloading SHA512SUMS.asc, aborting"
        exit 3
    }

    echo "Verifying SHA512SUMS"
    gpg2 --verify SHA512SUMS.asc || {
        echo "SHA512SUMS could not be verified, aborting process"
        exit 4
    }

    echo "Downloading $firefox_url"
    if [[ -f $firefox_file ]]; then
        echo "File $firefox_file exists, using it"
    else
        wget "$firefox_url" || {
            echo "Error downloading $firefox_url, aborting"
            exit 5
        }
    fi

    echo "Verifying $firefox_file"
    local file_info=($(cat SHA512SUMS | grep $firefox_file_path))
    local expected_checksum=$file_info[1]
    local checksum=$(sha512sum $firefox_file | awk '{print($1)}')
    if [[ $expected_checksum != $checksum ]]; then
        echo "Checksum for $firefox_file failed!"
        echo "   expected: $expected_checksum"
        echo "        got: $checksum"
        exit 6
    else
        echo "Checksum for $firefox_file valid ($expected_checksum)"
        echo "File located in $HOME/Downloads/firefox/$firefox_file"
    fi
}

if [[ $# -ne 1 ]]; then
    echo "Usage: download_firefox version"
    exit 1
fi

[ ! -d $HOME/Downloads/firefox ] &&  {
    echo "Directory $HOME/Downloads/firefox is needed before continue, please create it!"
    exit 1
}

pushd $HOME/Downloads/firefox
download_and_verify $1
popd
