#!/usr/bin/env ruby

require 'haml'
require 'pp'
require 'sinatra'
require 'sequel'
require 'set'

require_relative './geo_ip'

LOG_DB = false

DB = Sequel.sqlite('sql/geo_ip')
if (LOG_DB)
  require 'logger'
  DB.loggers << Logger.new(STDOUT)
end

geo_ips = DB['geo_ips']

get '/find' do
  title = 'Found IP'

  _ip = params['ip']
  decimal_ip = case _ip
               when /^\d+\.\d+\.\d+\.\d+$/ 
                 _ip.dec_IP_to_value 
               when /^\d+\:\d+\:\d+\:\d+$/ 
                 _ip.hex_IP_to_value
               else
                 nil
               end

  geo_ip = DB[:geo_ips].where('ip_from <= ? AND ? <= ip_to', decimal_ip, decimal_ip).first

  haml :find_result, {}, :title => title, :ip => _ip, :geo_ip => geo_ip
end

get '/' do
  title = 'Geo IP'

  haml :index, {}, :title => title # , :min_ip => min_ip, :max_ip => max_ip, :registries => registries, :countries => countries
end

# ctrys      = DB[ 'SELECT DISTINCT( ctry     ) FROM geo_ips ORDER BY ctry'     ].all.map{ |h| h[ :ctry     ] }
# cntrys     = DB[ 'SELECT DISTINCT( cntry    ) FROM geo_ips ORDER BY cntry'    ].all.map{ |h| h[ :cntry    ] }
# countries  = DB[ 'SELECT DISTINCT( country  ) FROM geo_ips ORDER BY country'  ].all.map{ |h| h[ :country  ] }
# registries = DB[ 'SELECT DISTINCT( registry ) FROM geo_ips ORDER BY registry' ].all.map{ |h| h[ :registry ] }
# 
# haml :index, {}, :title => title, :min_ip => min_ip, :max_ip => max_ip, :registries => registries, :countries => countries
