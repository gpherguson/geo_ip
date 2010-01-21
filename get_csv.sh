#!/bin/sh -x

wget http://software77.net/geo-ip?DL=2 -O ./IpToCountry.csv.zip
[ -f ./IpToCountry.csv.zip ] && unzip ./IpToCountry.csv.zip
[ -f ./IpToCountry.csv ] && /usr/bin/env ruby ./add_geo_ip_to_db.rb ./IpToCountry.csv

