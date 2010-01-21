#!/usr/bin/env ruby

# geo-ip database is available via wget from...
#
# http://software77.net/geo-ip/
#
# wget software77.net/geo-ip?DL=1 -O /path/to/IpToCountry.csv.gz   gzip
# wget software77.net/geo-ip?DL=2 -O /path/to/IpToCountry.csv.zip  zip
# wget software77.net/geo-ip?DL=3 -O /path/to/IpToCountry.csv.MD5  MD5 (CSV file)
# wget software77.net/geo-ip?DL=4 -O /path/to/IpToCountry.dat      Geo::IPfree
# wget software77.net/geo-ip?DL=5 -O /path/to/IpToCountry.dat.MD5  MD5 Geo::IPfree
# wget software77.net/geo-ip?DL=6 -O /path/to/country-codes.txt    Country Codes

module GEO_IP

  # Given an numerical IP number, return it in normal octet format.
  def to_octets
    raise ArgumentError if (self < 0 || self > 256**4 - 1)

    v = self

    # get the first octet
    octets = [ v / (256**3) ]
    v -= octets[-1] * (256**3)

    # get the second octet
    octets << v / (256**2)
    v -= octets[-1] * (256**2)

    # get the third octet
    octets << v / (256**1)

    # get the fourth octet
    octets << v - octets[-1] * (256**1)

    # return them
    octets
  end

  # Return the octets in decimal format: 
  #   127.0.0.1
  def to_dec_octets
    self.to_octets.join('.')
  end

  # Return the octets in hexadecimal format: 
  #   7f.0.0.1
  def to_hex_octets
    self.to_octets.map{ |i| '%02x' % i }.join('.')
  end
end

class Fixnum
  include GEO_IP
end

class Bignum
  include GEO_IP
end

class String
  # convert a string in decimal octet format to a value
  def dec_IP_to_value
    raise ArgumentError if (self[/^\d+\.\d+\.\d+\.\d+$/].nil?)
    octets = self.split('.').reverse
    value = 0
    octets.each_with_index do |_octet, _index|
      value += _octet.to_i * (256 ** _index)
    end
    value
  end

  def hex_IP_to_value
    raise ArgumentError if (self[/^[0-9a-f]{1,2}\.[0-9a-f]{1,2}\.[0-9a-f]{1,2}\.[0-9a-f]{1,2}$/].nil?)
    octets = self.split('.').reverse
    value = 0
    octets.each_with_index do |_octet, _index|
      value += _octet.hex * (256 ** _index)
    end
    value
  end
end

# [
#   ["0",         "16777215",  "410227200"],
#   ["50331648",  "67108863",  "572572800"],
#   ["67108864",  "83886079",  "723168000"],
#   ["100663296", "117440511", "760060800"],
#   ["117440512", "134217727", "880329600"],
#   ["134217728", "150994943", "723168000"],
#   ["150994944", "167772159", "598233600"]
# ].each do |i|
#   s, e, t = i
#   print s.to_i.to_hex_octets, "\t", e.to_i.to_hex_octets, "\t", Time.at(t.to_i).strftime('%Y-%m-%d'), "\n"
# end

class Geo_IP
  attr_accessor :ip_from, :ip_to, :registry, :assigned, :ctry, :cntry, :country

  def initialize(ip_from, ip_to, registry, assigned, ctry, cntry, country)
    
    # Validate the ip_from, ip_to, and assigned values to make sure they're
    # either Fixnum or Bignum numerics. This will raise an ArgumentError if
    # not, so wrap code creating instances of this class in a begin/rescue.
    @ip_from  = Integer(ip_from)
    @ip_to    = Integer(ip_to)
    @registry = registry
    @assigned = (assigned.is_a?(Time)) ? assigned : Time.at(Integer(assigned))
    @ctry     = ctry
    @cntry    = cntry
    @country  = country
  end

  def to_hash
    {
      :ip_from    => @ip_from,
      :ip_to      => @ip_to,
      :registry   => @registry,
      :created_on => @assigned, # map to created_on for any ActiveRecord users in the audience.
      :ctry       => @ctry,
      :cntry      => @cntry,
      :country    => @country
    }
  end
end

