# Branches

Original releases from each upstream and any updates are copied into the branch for each. Modifications have been applied within the respective branches in an attempt to track learnings and changes that better represent the configuration necessary to recreate the original artifacts.

## History

### 28mm

GitHub: [28mm/docker-wgrib2](https://github.com/28mm/docker-wgrib2) (https://github.com/28mm/docker-wgrib2)
Container: [DockerHub 28mm/wgrib2](https://hub.docker.com/r/28mm/wgrib2)  (https://hub.docker.com/r/28mm/wgrib2)

Only one [commit](https://github.com/28mm/docker-wgrib2/commit/15f284a5c3372672537053a26c4755785e56fa16) appears to have been made for the Dockerfile, Makefile, and accompanying README.md.  This occurred on 9 Dec 2018.

### PirateWeather

GitHub: [alexander0042/pirateweather](https://github.com/alexander0042/pirateweather/tree/main/wgrib2) (https://github.com/alexander0042/pirateweather/tree/main/wgrib2)
Container: [AWS ECR j9v4j3c7/pirate-wgrib2](https://gallery.ecr.aws/j9v4j3c7/pirate-wgrib2) (https://gallery.ecr.aws/j9v4j3c7/pirate-wgrib2)

Only one [commit](https://github.com/alexander0042/pirateweather/commit/1f380a272eac46a5efd167fe0a12b7500fdc7bc2) appears to have been made for the Dockerfile and accompanying README.md. This occurred on 5 Jan 2022.

Usage:

```shell
docker run -v "/mnt:/mnt" \
    -e bucket="noaa-hrrr-bdp-pds" \
    -e download_path="/mnt/efs" \
    -e download_path_mz="/mnt/efs1z" \
    -e temp_path="/mnt/efs1z/gfs/tmp" \
    -e time="2021-12-29T15:45:00Z" \
    public.ecr.aws/j9v4j3c7/pirate-wgrib2/mnt/efs1z/gfs/hrrrh_combined-fargate.py
```

## main

### lambda-wgrib2

wgrib2:        v3.1.2 *(with fixed makefile)
pywgrib2_s.py: v0.0.11 5/2020 \$5\$a31ea901d61d15d24edee7b4f23b0a8a0a3e5c6869b68e836d20ead4db724b20
cmake:         3.19.8

Uses public.ecr.aws/lambda/provided:al2.2023.03.21.13-x86_64

### lambda-pywgrib2_s

Uses public.ecr.aws/lambda/python:3.8.2023.03.21.13-x86_64

# Why?

A clearer picture is always welcome. Some of the details were implied at the time the files were originally made, but over time, other artifacts included in the composition had updates made replacing the original artifacts.
