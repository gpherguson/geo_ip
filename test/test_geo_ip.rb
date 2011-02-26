require 'minitest/autorun'

require_relative '../geo_ip'

# test Numeric.to_octet
class TestNumeric_to_octet < MiniTest::Unit::TestCase

  # do not replace the values
  def test_constants
    assert_equal( Geo_IP::MINIMUM_IP, 0          )
    assert_equal( Geo_IP::MAXIMUM_IP, 4294967295 ) # AKA (256**4 - 1)
  end

  def test_to_octet
    assert_instance_of( Array, 0.to_octets, "Didn't get an Array back")

    assert_equal( 0.to_octets.length, 4, "The array doesn't have four elements." )
    assert_equal( Geo_IP::MINIMUM_IP.to_octets, [0, 0, 0, 0],         "When given '#{ Geo_IP::MINIMUM_IP }', didn't receive [0,0,0,0] back." )
    assert_equal( Geo_IP::MAXIMUM_IP.to_octets, [255, 255, 255, 255], "When given '#{ Geo_IP::MAXIMUM_IP }', didn't receive '[255,255,255,255]' back."  )

    assert_raises(ArgumentError) { (Geo_IP::MINIMUM_IP - 1).to_octets }
    assert_raises(ArgumentError) { (Geo_IP::MAXIMUM_IP + 1).to_octets }
  end

  def test_to_hex_octets
    assert_equal( Geo_IP::MINIMUM_IP.to_hex_octets, '00.00.00.00' )
    assert_equal( Geo_IP::MAXIMUM_IP.to_hex_octets, 'ff.ff.ff.ff' )
  end

  def test_to_dec_octets
    assert_equal( Geo_IP::MINIMUM_IP.to_dec_octets, '0.0.0.0'         )
    assert_equal( Geo_IP::MAXIMUM_IP.to_dec_octets, '255.255.255.255' )
  end

  def test_dec_IP_to_value
    assert_equal( '0.0.0.0'.dec_IP_to_value,         Geo_IP::MINIMUM_IP )
    assert_equal( '255.255.255.255'.dec_IP_to_value, Geo_IP::MAXIMUM_IP )
  end

  def test_hex_IP_to_value
    assert_equal( '0.0.0.0'.hex_IP_to_value,     Geo_IP::MINIMUM_IP )
    assert_equal( 'ff.ff.ff.ff'.hex_IP_to_value, Geo_IP::MAXIMUM_IP )
  end

  def test_string_is_dec_IP?
    assert( '0.0.0.0'.is_dec_IP?         )
    assert( '255.255.255.255'.is_dec_IP? )

    assert( ! '0.0.0'.is_dec_IP?     )
    assert( ! '.0.0.0'.is_dec_IP?    )
    assert( ! '0.0.0.0.0'.is_dec_IP? )
    assert( ! '....'.is_dec_IP?      )
    assert( ! '0'.is_dec_IP?         )
    assert( ! '-1'.is_dec_IP?        )
  end

  def test_string_is_hex_IP?
    assert( '00.00.00.00'.is_hex_IP? )
    assert( 'ff.ff.ff.ff'.is_hex_IP? )

    assert( ! 'ff.ff.ff'.is_hex_IP?       )
    assert( ! '.ff.ff.ff'.is_hex_IP?      )
    assert( ! 'ff.ff.ff.ff.ff'.is_hex_IP? )
    assert( ! '....'.is_hex_IP?           )
    assert( ! '0'.is_hex_IP?              )
  end

end

