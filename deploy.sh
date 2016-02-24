#!/bin/bash

for i in `find packages/ubuntu/12.04 -name '*.deb'`; do
    package_cloud push flant/php_fpm_docker/ubuntu/precise $i
done
for i in `find packages/ubuntu/14.04 -name '*.deb'`; do
    package_cloud push flant/php_fpm_docker/ubuntu/trusty $i
done
