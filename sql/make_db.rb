#!/usr/bin/env ruby

require 'sequel'

DB_TYPE = :sqlite3 # or :postgres

DB_NAME  = 'geo_ip'
DB_TABLE = :geo_ips
DB_DSN   = 'postgres:user:passwd@host/' << DB_NAME

DB = case DB_TYPE
     when :sqlite3
       Sequel.sqlite(DB_NAME)
     when :postgres
       Sequel.connect(DB_DSN)
     end

DB.drop_table(DB_TABLE) if (DB.tables.include?(DB_TABLE))

DB.create_table(DB_TABLE) do
  primary_key :id
  String :ip_from,     :unique => true
  String :ip_to,       :unique => true
  String :registry,    :key    => true
  String :ctry,        :key    => true # :size => 2,
  String :cntry,       :key    => true # :size => 3,
  String :country,     :key    => true
  String :ip_from_dec, :unique => true
  String :ip_to_dec,   :unique => true
  String :ip_from_hex, :unique => true
  String :ip_to_hex,   :unique => true
  Date   :created_on,  :key    => true
end
