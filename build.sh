#!/bin/bash

# Exit on any non-zero status.
trap 'exit' ERR
set -E

# update system : bzip2 is needed when installing nodejs packages ...
apt-get -qy update
apt-get -qy --no-install-suggests --no-install-recommends install \
    xz-utils bzip2

echo "Add 'node' group and 'node' user (no HOME)"
groupadd -r node
useradd -r -g node node

echo "Installing NodeJs v${NODE_VERSION}"
# gpg keys listed at https://github.com/nodejs/node#release-team
for key in \
    94AE36675C464D64BAFA68DD7434390BDBE9B9C5 \
    B9AE9905FFD7803F25714661B63B535A4C206CA9 \
    77984A986EBC2AA786BC0F66B01FBB92821C587A \
    71DCFD284A79C3B38668286BC97EC7A07EDE3FC1 \
    FD3A5288F042B6850C66B31F09FE44734EB7990E \
    8FCCA13FEF1D0C2E91008E09770F7A9A5AE15600 \
    C4F0DFFF4E8C1A8236409D08E73BC641CC11F4C8 \
    DD8F2338BAE7501E3DD5AC78C273792F7D83545D \
; do \
    gpg --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys "$key" || \
    gpg --keyserver hkp://ipv4.pool.sks-keyservers.net --recv-keys "$key" || 
    gpg --keyserver hkp://pgp.mit.edu:80 --recv-keys "$key" ; \
done
curl -fsSLO --compress "https://nodejs.org/dist/v${NODE_VERSION}/node-v${NODE_VERSION}-linux-x64.tar.xz"    
curl -fsSLO --compress "https://nodejs.org/dist/v${NODE_VERSION}/SHASUMS256.txt.asc"
gpg --batch --decrypt --output SHASUMS256.txt SHASUMS256.txt.asc
grep " node-v${NODE_VERSION}-linux-x64.tar.xz\$" SHASUMS256.txt | sha256sum -c -
mkdir /usr/local/node-v${NODE_VERSION}
tar -xJf "node-v${NODE_VERSION}-linux-x64.tar.xz" -C /usr/local/node-v${NODE_VERSION}/ --strip-components=1 --no-same-owner
rm "node-v${NODE_VERSION}-linux-x64.tar.xz" SHASUMS256.txt.asc SHASUMS256.txt
ln -s /usr/local/node-v${NODE_VERSION}/bin/node /usr/local/node-v${NODE_VERSION}/bin/nodejs
export PATH=${PATH}:/usr/local/node-v${NODE_VERSION}/bin

echo "Installing Yarn v${YARN_VERSION}"
curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | gpg --import
curl -fsSLO --compress "https://github.com/yarnpkg/yarn/releases/download/v${YARN_VERSION}/yarn-v${YARN_VERSION}.tar.gz"
curl -fsSLO --compress "https://github.com/yarnpkg/yarn/releases/download/v${YARN_VERSION}/yarn-v${YARN_VERSION}.tar.gz.asc"
gpg --batch --verify yarn-v${YARN_VERSION}.tar.gz.asc yarn-v${YARN_VERSION}.tar.gz
tar -xzf yarn-v${YARN_VERSION}.tar.gz -C /usr/local/ --no-same-owner 
rm "yarn-v${YARN_VERSION}.tar.gz.asc" "yarn-v${YARN_VERSION}.tar.gz"
export PATH=${PATH}:usr/local/yarn-v${YARN_VERSION}/bin

echo "Install some yarn packages : gulp-cli"
mkdir /usr/local/yarn-v${YARN_VERSION}/.config-global
yarn config set prefix /usr/local/yarn-v${YARN_VERSION}/.config-global
yarn global add \
    gulp-cli@${GULPCLI_VERSION}

# clean :
apt-get purge -y --auto-remove \
    xz-utils
apt-get clean
rm -rf /var/lib/apt/lists/*

exit 0

