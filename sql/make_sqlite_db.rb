#!/usr/bin/env ruby

require 'sequel'

DB_TYPE = :sqlite3 # or :postgres

DB = case DB_TYPE
     when :sqlite3
       Sequel.sqlite('geo_ip')
     when :postgres
       Sequel.connect('postgres:user:passwd@host/geo_ip')
     end

DB.drop_table(:geo_ips) if (DB.tables.include?(:geo_ips))

DB.create_table :geo_ips do
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
