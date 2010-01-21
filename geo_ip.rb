module GEO_IP

  # Given a Fixnum or Bignum value, return it as an array of four octet values.
  #
  # Values < 0 or > 4294967295 raise an ArgumentError.
  #
  #   0.to_octets          => [0,0,0,0]
  #   4294967295.to_octets => [255,255,255,255]
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

  # Given a Fixnum or Bignum, return the value in decimal octet format:
  #
  #   0.to_dec_octets          => "0.0.0.0"
  #   4294967295.to_dec_octets => "255.255.255.255"
  def to_dec_octets
    self.to_octets.join('.')
  end

  # Given a Fixnum or Bignum, return the value in hexadecimal octet format:
  #
  #   0.to_hex_octets          => "00.00.00.00"
  #   4294967295.to_hex_octets => "ff.ff.ff.ff"
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

  # Convert a string in decimal octet format to a value.
  #
  # Returns a Fixnum or Bignum version of the decimal IP number.
  #
  #   '0.0.0.0'.hex_IP_to_value         => 0
  #   '255.255.255.255'.hex_IP_to_value => 4294967295
  def dec_IP_to_value
    raise ArgumentError if (self[/^\d+\.\d+\.\d+\.\d+$/].nil?)
    octets = self.split('.').reverse
    value = 0
    octets.each_with_index do |_octet, _index|
      value += _octet.to_i * (256 ** _index)
    end
    value
  end

  # Convert a string in hexadecimal octet format to a value.
  #
  # Returns a Fixnum or Bignum version of the hexadecimal IP number.
  #
  #   '00.00.00.00'.hex_IP_to_value => 0
  #   'ff.ff.ff.ff'.hex_IP_to_value => 4294967295
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

# Contains the basic fields for an IP record. Maybe this should be expanded to
# hold the decimal and hexadecimal versions of the IP numbers, but it's easy
# enough to compute them when needed on the fly.
#
# See the header for the IpToCountry.csv file for the meanings of the fields.
class Geo_IP
  attr_accessor :ip_from, :ip_to, :registry, :assigned, :ctry, :cntry, :country

  def initialize(ip_from, ip_to, registry, assigned, ctry, cntry, country)
    
    # Validate @ip_from, @ip_to, and @assigned values to make sure they're
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

  # Return the instance as a hash.
  # 
  # @assigned is mapped to created_on in the database for ActiveRecord
  # compatibility.
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

