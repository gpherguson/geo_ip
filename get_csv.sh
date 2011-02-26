#!/bin/sh -x

#!/bin/sh

# curl http://software77.net/geo-ip?DL=2 -O ./IpToCountry.csv.zip
ruby -rhttpclient -e 'puts HTTPClient.get_content(ARGV.shift)' 'http://software77.net/geo-ip?DL=2' > ./IpToCountry.csv.zip
[ -f ./IpToCountry.csv.zip ] && unzip ./IpToCountry.csv.zip
[ -f ./IpToCountry.csv ] && /usr/bin/env ruby ./add_geo_ip_to_db.rb ./IpToCountry.csv

