#!/bin/bash
#
# SPDX-License-Identifier: Apache-2.0

function _exit(){
    printf "Exiting:%s\n" "$1"
    exit -1
}

# Exit on first error, print all commands.
set -ev
set -o pipefail

# Where am I?
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

export FABRIC_CFG_PATH="${DIR}/../config"

cd "${DIR}/../test-network/"

docker kill cliDigiBank cliMagnetoCorp logspout || true
./network.sh down
./network.sh up createChannel -ca -s couchdb

# Copy the connection profiles so they are in the correct organizations.
cp "${DIR}/../test-network/organizations/peerOrganizations/org1.o3.fit/connection-org1.yaml" "${DIR}/organization/digibank/gateway/"
cp "${DIR}/../test-network/organizations/peerOrganizations/org2.o3.fit/connection-org2.yaml" "${DIR}/organization/magnetocorp/gateway/"

cp "${DIR}/../test-network/organizations/peerOrganizations/org1.o3.fit/users/User1@org1.o3.fit/msp/signcerts/"* "${DIR}/../test-network/organizations/peerOrganizations/org1.o3.fit/users/User1@org1.o3.fit/msp/signcerts/User1@org1.o3.fit-cert.pem"
cp "${DIR}/../test-network/organizations/peerOrganizations/org1.o3.fit/users/User1@org1.o3.fit/msp/keystore/"* "${DIR}/../test-network/organizations/peerOrganizations/org1.o3.fit/users/User1@org1.o3.fit/msp/keystore/priv_sk"

cp "${DIR}/../test-network/organizations/peerOrganizations/org2.o3.fit/users/User1@org2.o3.fit/msp/signcerts/"* "${DIR}/../test-network/organizations/peerOrganizations/org2.o3.fit/users/User1@org2.o3.fit/msp/signcerts/User1@org2.o3.fit-cert.pem"
cp "${DIR}/../test-network/organizations/peerOrganizations/org2.o3.fit/users/User1@org2.o3.fit/msp/keystore/"* "${DIR}/../test-network/organizations/peerOrganizations/org2.o3.fit/users/User1@org2.o3.fit/msp/keystore/priv_sk"

echo Suggest that you monitor the docker containers by running
echo "./organization/magnetocorp/configuration/cli/monitordocker.sh fabric_test"
