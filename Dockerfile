FROM		ubuntu:trusty

MAINTAINER	Victor M. Varela <vvvarela@neartechnologies.com>

ENV             DEBIAN_FRONTEND noninteractive
ENV		_BUILD_DEPS	libgdal-dev gdal-bin python-gdal libgrib-api-dev libproj-dev \
				libblas-dev liblapack-dev gfortran g++ libjson-c-dev wget \
				make

ADD		requirements.txt	/
RUN		apt-get update \
	&&	apt-get install -yqq --no-install-recommends \
			software-properties-common python-software-properties python-pip \
			libpython2.7 \
	&&	add-apt-repository "deb http://python-bufr.googlecode.com/svn/apt lucid main" \
	&&	add-apt-repository ppa:mapnik/nightly-trunk \
	&&	add-apt-repository ppa:ubuntugis/ubuntugis-unstable \
	&&	apt-get update \
	&&	apt-get install -yqq --no-install-recommends --force-yes python-bufr emos \
	&&	apt-get install -yqq --no-install-recommends \
			python-pyste python-numpy \
			libmapnik libmapnik-dev mapnik-utils python-mapnik \
			mapnik-input-plugin-gdal mapnik-input-plugin-ogr \
			mapnik-input-plugin-postgis \
			mapnik-input-plugin-sqlite \
			mapnik-input-plugin-osm \
			$_BUILD_DEPS \
	&&	ln -sf /bin/sh /usr/bin/sh && ln -s /usr/include/json-c /usr/include/json \
	&&	wget -P /tmp https://software.ecmwf.int/wiki/download/attachments/35752466/bufrdc_000403.tar.gz \
	&&	tar xvzf /tmp/bufrdc_000403.tar.gz -C /tmp \
	&&	cd /tmp/bufrdc_000403 && (echo y; echo y; echo /usr/local/lib) | sh build_library && ./install \
	&&	CPLUS_INCLUDE_PATH=/usr/include/gdal C_INCLUDE_PATH=/usr/include/gdal \
		pip install GDAL==1.11.1 \
	&&	pip install -r /requirements.txt \
	&&	rm -rf /tmp/* \
	&&	apt-get -y purge $_BUILD_DEPS \
	&&	apt-get -y autoremove \
	&&	apt-get clean 

CMD		/bin/bash

