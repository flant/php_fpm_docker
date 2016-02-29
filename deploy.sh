#!/bin/bash

for RELEASE in 12.04 14.04 14.04-5.3 14.04-5.5-latest 14.04-5.6; do
if [ -d packages/ubuntu/"$RELEASE" ]; then
for PACKAGE in `find packages/ubuntu/"$RELEASE" -maxdepth 1 -name '*.deb'`; do
    package_cloud yank flant/php_fpm_docker/ubuntu/precise $PACKAGE
    package_cloud push flant/php_fpm_docker/ubuntu/precise $PACKAGE
done
fi
done
