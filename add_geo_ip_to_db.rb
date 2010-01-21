#!/usr/bin/env ruby

require 'csv'
require 'iconv' 

require 'rubygems'
require 'sequel'

require 'geo_ip'

LOG_DB = false

# Store a geo_ip object to the database.
def store_geo_ip_to_db(g)
  geo_ip = g.to_hash

  geo_ip[ :ip_from_dec ] = geo_ip[ :ip_from ].to_dec_octets
  geo_ip[ :ip_to_dec   ] = geo_ip[ :ip_to   ].to_dec_octets
  geo_ip[ :ip_from_hex ] = geo_ip[ :ip_from ].to_hex_octets
  geo_ip[ :ip_to_hex   ] = geo_ip[ :ip_to   ].to_hex_octets

  DB[:geo_ip].insert(geo_ip)
rescue Exception => e
  print e
end

# the name of the csv file will be passed in on the command line...
geo_ip_csv = ARGV.first 
if (geo_ip_csv.nil?)
  print "Missing filename\n"
  exit
end

DB = Sequel.connect('postgres://postgres:password@localhost/geo_ip')
if (LOG_DB)
  require 'logger'
  DB.loggers << Logger.new(STDOUT)
end

# Delete the existing records from the database. This might be slower than a
# SQL truncate.
DB[:geo_ip].delete

conv = Iconv.new('UTF-8', 'ISO-8859-1') 
line_num = 0

IO.foreach(geo_ip_csv) do |_line| 
  line_num += 1

  # ignore comments
  next if (_line[0, 1] == '#')

  converted_line = conv.iconv(_line) 

  # create a new instance of the object
  # geo_ip = Geo_IP.new(*CSV.parse_line(_line).map{ |_i| _i.data })
  geo_ip = Geo_IP.new(*CSV.parse_line(converted_line))

  begin
    # write it to the database
    store_geo_ip_to_db(geo_ip)

    # show what we got
    # print [geo_ip.ip_from.to_hex_octets, geo_ip.ip_to.to_hex_octets, geo_ip.assigned.strftime('%Y-%m-%d')].join("\t"), "\n"
  rescue PGError => e
    $stderr.print "#{ e.msg } at line: #{ line_num }\n"
  rescue Exception => e
    # complain if there is a problem, but don't stop.
    $stderr.print "#{ e.msg } at line: #{ line_num }\n"
  end
end 

print DB[:geo_ip].count, " records available.\n"

