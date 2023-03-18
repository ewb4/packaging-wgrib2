FROM alpine:3.8.5

RUN apk add --no-cache gcc musl-dev gfortran make

ENV COMP_SYS gnu_linux
ENV CC gcc
ENV FC gfortran

COPY 3rd-party/wgrib2.tgz .
RUN tar -xzf wgrib2.tgz \
  && cd grib2 \
  && make

ENTRYPOINT [ "/grib2/wgrib2/wgrib2" ]
