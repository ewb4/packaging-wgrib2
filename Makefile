3rd-party/wgrib2.tgz:
	curl https://www.ftp.cpc.ncep.noaa.gov/wd51we/wgrib2/wgrib2.tgz.v2.0.7 -o 3rd-party/wgrib2.tgz

.PHONY: build
build: 3rd-party/wgrib2.tgz
	docker build -t 28mm/wgrib2 .

.PHONY: publish
publish:
	docker push 28mm/wgrib2:latest
