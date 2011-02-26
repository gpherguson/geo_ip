Run make_db.rb to create the SQLite3 version of the geo_ip database. 

To switch to Postgres, edit the DB_TYPE constant, create the "geo_ip" database
using psql, then modify the DB_DSN with the appropriate connection and login
info, then, finally, run the script.
