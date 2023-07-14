# ======================================================================
# Dockerfile to compile wgrib2 based on Ubuntu linux 22.04
#
#           Homepage: http://www.cpc.ncep.noaa.gov/products/wesley/wgrib2/
# Available versions: ftp://ftp.cpc.ncep.noaa.gov/wd51we/wgrib2/
# ======================================================================

FROM ubuntu:22.04 AS base

ENV COMP_SYS=gnu_linux
ENV CC=gcc
ENV FC=gfortran

RUN apt-get update && apt-get install -y build-essential gfortran wget file pip

RUN wget -q -O /tmp/wgrib2.tgz https://ftp.cpc.ncep.noaa.gov/wd51we/wgrib2/wgrib2.tgz.v3.1.0 && \
      tar -xzf /tmp/wgrib2.tgz -C /tmp

WORKDIR /tmp/grib2

RUN sed -i "s|MAKE_SHARED_LIB=0|MAKE_SHARED_LIB=1|g" makefile && \
      make lib

RUN cp /tmp/grib2/lib/libwgrib2.so /usr/lib/python3/libwgrib2.so && \
      python3 -m pip install numpy boto3 netCDF4

RUN wget -q -O - https://ftp.cpc.ncep.noaa.gov/wd51we/pywgrib2_s/pywgrib2_s.tgz.v0.0.11 | \
      tar -x -C /usr/lib/python3 -z -f - --strip-components=1 pywgrib2_s/pywgrib2_s.py

ENTRYPOINT ["python3"]
