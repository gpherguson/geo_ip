#!/usr/bin/env ruby

require 'csv'
require 'iconv' 

require 'rubygems'
require 'sequel'

# use "require" for Ruby < 1.9.2
require_relative './geo_ip'

LOG_DB = false

# Store a geo_ip object to the database.
def store_geo_ip_to_db(g)
  geo_ip = g.to_hash

  geo_ip[ :ip_from_dec ] = geo_ip[ :ip_from ].to_dec_octets
  geo_ip[ :ip_to_dec   ] = geo_ip[ :ip_to   ].to_dec_octets
  geo_ip[ :ip_from_hex ] = geo_ip[ :ip_from ].to_hex_octets
  geo_ip[ :ip_to_hex   ] = geo_ip[ :ip_to   ].to_hex_octets

  DB[:geo_ips].insert(geo_ip)
rescue Exception => e
  print e
end

# the name of the csv file will be passed in on the command line...
geo_ip_csv = ARGV.first 
if (geo_ip_csv.nil?)
  print "Missing filename\n"
  exit
end

# DB = Sequel.connect('postgres://userid:password@host/geo_ip')
DB = Sequel.sqlite('sql/geo_ip')
if (LOG_DB)
  require 'logger'
  DB.loggers << Logger.new(STDOUT)
end

puts "Truncating the table..."
DB[:geo_ips].truncate

conv = Iconv.new('UTF-8', 'ISO-8859-1') 

# count the number of lines in the file.
lines_to_read = File.open('IpToCountry.csv','r') { |fi| fi.lines.count }
puts "#{ lines_to_read } lines to read."

STDOUT.sync = true

line_num = 0
running = true

# let a timer handle updating the status every second
timer = Thread.new do
  while (running) do
    sleep 1
    print "%.1f%% %d\r" % [ line_num.to_f / lines_to_read * 100, line_num ]
  end
end

# loop over the file and store the records in the database.
IO.foreach(geo_ip_csv) do |_line| 

  line_num += 1

  # ignore comments
  next if (_line[0, 1] == '#')

  converted_line = conv.iconv(_line) 

  # create a new instance of the object
  geo_ip = Geo_IP.new(*CSV.parse_line(converted_line))

  begin
    # write it to the database
    store_geo_ip_to_db(geo_ip)

    # show what we got
    # print [geo_ip.ip_from.to_hex_octets, geo_ip.ip_to.to_hex_octets, geo_ip.assigned.strftime('%Y-%m-%d')].join("\t"), "\n"
  # rescue PGError => e
  #   $stderr.print "#{ e.msg } at line: #{ line_num }\n"
  rescue Exception => e
    # complain if there is a problem, but don't stop.
    $stderr.print "#{ e.msg } at line: #{ line_num }\n"
  end
end 

running = false
timer.join

print DB[:geo_ips].count, " records available.\n"

