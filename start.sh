#!/bin/bash

echo "REPO=${REPO}"
echo "NAME=${NAME}"
#echo "REG_TOKEN=${REG_TOKEN}"

if [ -z "${REPO}" -o -z "${NAME}" -o -z "${REG_TOKEN}"  ]; then
  echo "REPO, NAME or REG_TOKEN is not set. Exiting."
  #exit 1
fi

echo "Config GitHub Actions..."
cd /home/docker/actions-runner || exit
./config.sh --url https://github.com/${REPO} --token ${REG_TOKEN} --name ${NAME} --runnergroup Default --unattended --replace --work _work --labels docker,linux,x64 --ephemeral

cleanup() {
  echo "Removing runner..."
  ./config.sh remove --unattended --token ${REG_TOKEN}
}

trap 'cleanup; exit 130' INT
trap 'cleanup; exit 143' TERM


echo "Starting GitHub Actions runner..."
./run.sh & wait $!