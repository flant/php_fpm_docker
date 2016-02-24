JOBS := $(shell grep processor /proc/cpuinfo | wc -l)
TOP := $(abspath $(dir $(lastword $(MAKEFILE_LIST))))

all: ubuntu-14.04 ubuntu-12.04 ubuntu-14.04-php-5.3 ubuntu-14.04-php-5.5-latest ubuntu-14.04-php-5.6

clean:
	rm -rf build packages

build-ubuntu-14.04:
	apt-get build-dep -y php5-fpm
	cd /build; apt-get source php5-fpm
	cd /build/php5-5.5*; \
		sed 's/a\//php5.orig\/sapi\/fpm\//g; s/b\//php5\/sapi\/fpm\//g' /sources/php_fpm.diff > debian/patches/php_fpm_docker.patch; \
		sed -i '/php_fpm_docker\.patch/d' debian/patches/series; \
		echo php_fpm_docker.patch >> debian/patches/series
	cd /build/php5-5.5*; DEB_BUILD_OPTIONS=nocheck dpkg-buildpackage -b -us -uc -j$(JOBS) | tail -n200
	cp /build/php5-fpm* /packages

ubuntu-14.04:
	docker run --rm \
		-v $(TOP):/sources:ro \
		-v $(TOP)/build/build_dir/ubuntu/14.04/default:/build \
		-v $(TOP)/packages/ubuntu/14.04:/packages \
		-v $(TOP)/build/cache/ubuntu/14.04/apt_cache:/var/cache/apt/ \
		-v $(TOP)/build/cache/ubuntu/14.04/apt_lists:/var/lib/apt/lists/ \
		-e DEBIAN_FRONTEND=noninteractive \
		ubuntu:14.04 \
		bash -ec 'trap "exit" SIGINT; bash -ec "rm -f /etc/apt/apt.conf.d/docker-clean; apt-get update; apt-get install -y make; make -C /sources build-ubuntu-14.04" & wait'

build-ubuntu-12.04:
	apt-get build-dep -y php5-fpm
	apt-get install -y language-pack-de
	cd /build; apt-get source php5-fpm
	cd /build/php5-5.3*; \
		sed 's/a\//php5.orig\/sapi\/fpm\//g; s/b\//php5\/sapi\/fpm\//g' /sources/php_fpm.diff > debian/patches/php_fpm_docker.patch; \
		sed -i '/php_fpm_docker\.patch/d' debian/patches/series; \
		echo php_fpm_docker.patch >> debian/patches/series
	cd /build/php5-5.3*; DEB_BUILD_OPTIONS=nocheck dpkg-buildpackage -b -us -uc -j$(JOBS) | tail -n200
	cp /build/php5-fpm* /packages/ubuntu/12.04
	echo /packages/ubuntu/12.04; ls -l /packages/ubuntu/12.04
	echo /packages; ls -l /packages/

ubuntu-12.04:
	docker run --rm \
		-v $(TOP):/sources:ro \
		-v $(TOP)/build/build_dir/ubuntu/12.04/default:/build \
		-v $(TOP)/packages/ubuntu/12.04:/packages \
		-v $(TOP)/build/cache/ubuntu/12.04/apt_cache:/var/cache/apt/ \
		-v $(TOP)/build/cache/ubuntu/12.04/apt_lists:/var/lib/apt/lists/ \
		-e DEBIAN_FRONTEND=noninteractive \
		ubuntu:12.04 \
		bash -ec 'trap "exit" SIGINT; bash -ec "rm -f /etc/apt/apt.conf.d/docker-clean; apt-get update; apt-get install -y make; make -C /sources build-ubuntu-12.04" & wait'

build-ubuntu-14.04-php-5.3:
	apt-get install -y software-properties-common
	add-apt-repository --enable-source ppa:hentenaar/php
	apt-get update
	apt-get build-dep -y php5-fpm=5.3
	cd /build; apt-get source php5-fpm=5.3
	cd /build/php5-5.3*; \
		sed 's/a\//php5.orig\/sapi\/fpm\//g; s/b\//php5\/sapi\/fpm\//g' /sources/php_fpm.diff > debian/patches/php_fpm_docker.patch; \
		sed -i '/php_fpm_docker\.patch/d' debian/patches/series; \
		echo php_fpm_docker.patch >> debian/patches/series
	cd /build/php5-5.3*; DEB_BUILD_OPTIONS=nocheck dpkg-buildpackage -b -us -uc -j$(JOBS) | tail -n200
	cp /build/php5-fpm* /packages

ubuntu-14.04-php-5.3:
	docker run --rm \
		-v $(TOP):/sources:ro \
		-v $(TOP)/build/build_dir/ubuntu/14.04/5.3:/build \
		-v $(TOP)/packages/ubuntu/14.04:/packages \
		-v $(TOP)/build/cache/ubuntu/14.04/apt_cache:/var/cache/apt/ \
		-v $(TOP)/build/cache/ubuntu/14.04/apt_lists:/var/lib/apt/lists/ \
		-e DEBIAN_FRONTEND=noninteractive \
		ubuntu:14.04 \
		bash -ec 'trap "exit" SIGINT; bash -ec "rm -f /etc/apt/apt.conf.d/docker-clean; apt-get update; apt-get install -y make; make -C /sources build-ubuntu-14.04-php-5.3" & wait'

build-ubuntu-14.04-php-5.5-latest:
	apt-get install -y software-properties-common language-pack-en-base
	LC_ALL=en_US.UTF-8 add-apt-repository --enable-source ppa:ondrej/php5
	apt-get update
	apt-get build-dep -y php5-fpm
	cd /build; apt-get source php5-fpm
	cd /build/php5-5.5*; \
		sed 's/a\//php5.orig\/sapi\/fpm\//g; s/b\//php5\/sapi\/fpm\//g' /sources/php_fpm.diff > debian/patches/php_fpm_docker.patch; \
		sed -i '/php_fpm_docker\.patch/d' debian/patches/series; \
		echo php_fpm_docker.patch >> debian/patches/series
	cd /build/php5-5.5*; DEB_BUILD_OPTIONS=nocheck dpkg-buildpackage -b -us -uc -j$(JOBS) | tail -n200
	cp /build/php5-fpm* /packages

ubuntu-14.04-php-5.5-latest:
	docker run --rm \
		-v $(TOP):/sources:ro \
		-v $(TOP)/build/build_dir/ubuntu/14.04/5.5-latest:/build \
		-v $(TOP)/packages/ubuntu/14.04:/packages \
		-v $(TOP)/build/cache/ubuntu/14.04/apt_cache:/var/cache/apt/ \
		-v $(TOP)/build/cache/ubuntu/14.04/apt_lists:/var/lib/apt/lists/ \
		-e DEBIAN_FRONTEND=noninteractive \
		ubuntu:14.04 \
		bash -ec 'trap "exit" SIGINT; bash -ec "rm -f /etc/apt/apt.conf.d/docker-clean; apt-get update; apt-get install -y make; make -C /sources build-ubuntu-14.04-php-5.5-latest" & wait'

build-ubuntu-14.04-php-5.6:
	apt-get install -y software-properties-common language-pack-en-base quilt
	LC_ALL=en_US.UTF-8 add-apt-repository --enable-source ppa:ondrej/php5-5.6
	apt-get update
	apt-get build-dep -y php5-fpm
	cd /build; apt-get source php5-fpm
	cd /build/php5-5.6*; \
		sed 's/a\//php5.orig\/sapi\/fpm\//g; s/b\//php5\/sapi\/fpm\//g' /sources/php_fpm.diff > debian/patches/php_fpm_docker.patch; \
		sed -i '/php_fpm_docker\.patch/d' debian/patches/series; \
		echo php_fpm_docker.patch >> debian/patches/series; \
		quilt push -a
	cd /build/php5-5.6*; DEB_BUILD_OPTIONS=nocheck dpkg-buildpackage -b -us -uc -j$(JOBS) | tail -n200
	cp /build/php5-fpm* /packages

ubuntu-14.04-php-5.6:
	docker run --rm \
		-v $(TOP):/sources:ro \
		-v $(TOP)/build/build_dir/ubuntu/14.04/5.6:/build \
		-v $(TOP)/packages/ubuntu/14.04:/packages \
		-v $(TOP)/build/cache/ubuntu/14.04/apt_cache:/var/cache/apt/ \
		-v $(TOP)/build/cache/ubuntu/14.04/apt_lists:/var/lib/apt/lists/ \
		-e DEBIAN_FRONTEND=noninteracive \
		ubuntu:14.04 \
		bash -ec 'trap "exit" SIGINT; bash -ec "rm -f /etc/apt/apt.conf.d/docker-clean; apt-get update; apt-get install -y make; make -C /sources build-ubuntu-14.04-php-5.6" & wait'
