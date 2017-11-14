#!/usr/bin/env bash

declare -r IMAGE_NAME='freedomben/java'
declare -r DOCKERFILE='Dockerfile'

declare JAVA_VER=''  # gets set from first arg to script

die ()
{
    echo "[die]: $1"
    exit 1
}

docker_build ()
{
    docker build -t "$IMAGE_NAME:$JAVA_VER" -t "$IMAGE_NAME:latest" -f $DOCKERFILE --build-arg JAVA_VER=${JAVA_VER} .
}

main ()
{
    [ -f "$DOCKERFILE" ]      || die "Cant find expected file '$DOCKERFILE'"
    [ -n "$1" ]               || die "Must specify Java version to build. Please pass '8' or '9' as argument"
    JAVA_VER="$1"
    [[ "$JAVA_VER" =~ [89] ]] || die "Please pass '8' or '9' as argument"
    docker_build
}

main $@
