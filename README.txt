Some fiddling/meddling with IP addresses, using the IpToCountry.csv file
available from http://Software77.net. See http://software77.net/geo-ip/ for
more information.

Feel free to fiddle with the code too, but there is no guarantee it will work
correctly, or incorrectly, or at all, for you. I'm amazed it works for me
actually.

The backing database was originally built using Postgresql on my system, but I
switched to SQLite3 for ease of maintenance. The schema file is available in
the sql/schema file. Run the sql/make_db.rb script to build the table. Read the
sql/README.txt file if you want a bit more information.

Unit tests using Ruby's MiniTest are in test/test_geo_ip.rb.

Use get_csv.sh to retrieve, and unzip, the IpToCountry.csv file and launch
add_geo_ip_to_db.rb. (Or not. Again, there is no guarantee any of this will work
for you.)

