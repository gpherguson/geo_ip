#!/usr/bin/bacon

# Bacon unit test file

require 'geo_ip'

# test Numeric.to_octet
describe 'Numeric.to_octet' do
  it 'should return an array for 0.to_octet' do
    0.to_octets.class.to_s.should.equal 'Array'
  end

  it 'should have four elements for 0.to_octets' do
    0.to_octets.length.should.equal 4
  end

  it 'should return [0,0,0,0] for 0.to_octets' do
    0.to_octets.should.equal [0,0,0,0]
  end

  it 'should return [255,255,255,255] for 4294967295.to_octets' do
    4294967295.to_octets.should.equal [255,255,255,255]
  end

  it 'should raise ArgumentError for < 0.to_octets' do
    should.raise(ArgumentError) { -1.to_octets }
  end

  it 'should raise ArgumentError for > 4294967295.to_octets' do
    should.raise(ArgumentError) { 4294967296.to_octets }
  end
end

# test Numeric.to_hex_octets
describe 'Numeric.to_hex_octets' do
  it 'should return "00.00.00.00" for 0.to_octets' do
    0.to_hex_octets.should.equal '00.00.00.00'
  end

  it 'should return "ff.ff.ff.ff" for 4294967295.to_hex_octets' do
    4294967295.to_hex_octets.should.equal 'ff.ff.ff.ff'
  end
end

# test Numeric.to_dec_octets
describe '0.to_dec_octets' do
  it 'should return "0.0.0.0" for 0.to_dec_octets' do
    0.to_dec_octets.should.equal '0.0.0.0'
  end

  it 'should return "255.255.255.255" for 4294967295.to_dec_octets' do
    4294967295.to_dec_octets.should.equal '255.255.255.255'
  end
end

# test String.dec_IP_to_value
describe 'String.dec_IP_to_value' do
  it 'should return 0 for "0.0.0.0".dec_IP_to_value' do
    '0.0.0.0'.dec_IP_to_value.should.equal 0
  end

  it 'should return 4294967295 for "255.255.255.255".dec_IP_to_value' do
    "255.255.255.255".dec_IP_to_value.should.equal 4294967295
  end
end

# test String.hex_IP_to_value
describe 'String.hex_IP_to_value' do
  it 'should return 0 for "00.00.00.00".hex_IP_to_value' do
    '0.0.0.0'.hex_IP_to_value.should.equal 0
  end

  it 'should return 4294967295 for "ff.ff.ff.ff".hex_IP_to_value' do
    'ff.ff.ff.ff'.hex_IP_to_value.should.equal 4294967295
  end
end

