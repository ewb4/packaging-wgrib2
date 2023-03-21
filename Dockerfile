FROM public.ecr.aws/lambda/provided:al2.2023.03.21.13-x86_64 as builder

RUN yum install --setopt=tsflags=nodocs -y \
      tar \
      gzip \
      gcc-gfortran \
      make \
      which \
    && yum clean all \
    && rm -rf /var/cache/yum

## Cmake available for current AWS Lambda base is not new enough
# https://www.matbra.com/2017/12/07/install-cmake-on-aws-linux.html

## the "which" command is requisite for the wgrib2 makefile to locate cmake

ENV COMP_SYS=gnu_linux
ENV CC=gcc
ENV FC=gfortran

COPY 3rd-party/cmake.tgz .
RUN yum install --setopt=tsflags=nodocs -y \
      gcc-c++ \
      openssl-devel \
    && yum clean all \
    && rm -rf /var/cache/yum
RUN tar -xzf cmake.tgz \
  && cd cmake-3.19.8 \
  && ./bootstrap --prefix=/usr \
  && make \
  && make install

COPY 3rd-party/wgrib2.tgz .
COPY wgrib2-v3.1.2-fixed-makefile .

RUN tar -xzf wgrib2.tgz \
  && cd grib2 \
  && mv makefile makefile.orig \
  && mv ../wgrib2-v3.1.2-fixed-makefile makefile \
  && sed -i "s|MAKE_SHARED_LIB=0|MAKE_SHARED_LIB=1|g" makefile \
  && make lib \
  && make \
  && /usr/bin/strip ./wgrib2/wgrib2

FROM public.ecr.aws/lambda/provided:al2.2023.03.21.13-x86_64 as lambda-base
RUN yum install --setopt=tsflags=nodocs -y \
      libgfortran \
      libgomp \
    && yum clean all \
    && rm -rf /var/cache/yum

COPY --from=builder /var/task/grib2/wgrib2/wgrib2 /opt/wgrib2/bin/wgrib2
COPY --from=builder /var/task/grib2/lib/libwgrib2.so /opt/wgrib2/lib/libwgrib2.so
COPY 3rd-party/pywgrib2_s/pywgrib2_s.py /opt/wgrib2/python/pywgrib2_s.py

ENTRYPOINT [ "/opt/wgrib2/bin/wgrib2" ]

FROM public.ecr.aws/lambda/python:3.8.2023.03.21.13-x86_64 as lambda-pybase

RUN yum install --setopt=tsflags=nodocs -y libgfortran libgomp && yum clean all && rm -rf /var/cache/yum \
  && /var/lang/bin/python3 -m pip install numpy boto3 netCDF4 kerchunk
# https://stackoverflow.com/questions/61276309/how-to-shrink-large-python-package-for-aws-lambda-layer
#RUN yum install --setopt=tsflags=nodocs -y libgfortran libgomp && yum clean all && rm -rf /var/cache/yum \
#  && /var/lang/bin/python3 -m pip install numpy boto3 netCDF4 kerchunk \
#  && find /var/lang/ -type d \( -name "tests" -o -name "docs" -o -name "__pycache__" \) -print0 | \
#       xargs -0 -n1 rm -rvf

COPY --from=builder /var/task/grib2/lib/libwgrib2.so /var/lang/lib/libwgrib2.so
COPY 3rd-party/pywgrib2_s/pywgrib2_s.py /opt/wgrib2/lib/python/pywgrib2_s.py

ENTRYPOINT [ "python3" ]
