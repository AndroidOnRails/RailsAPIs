require './get_current.rb'
require 'sqlite3'

def calculateLastMinMax(curr_data)
	x = Hash['last_hour_min'=> -1,
			 'last_day_min'=> -1,
			 'last_week_min'=> -1,
			 'last_month_min'=> -1,
			 'last_hour_max'=> -1,
			 'last_day_max'=> -1,
			 'last_week_max'=> -1,
			 'last_month_max'=> -1]
	return x
end

begin
	db = SQLite3::Database.open "development.sqlite3"
	db.execute "CREATE TABLE IF NOT EXISTS currents(
				id INTEGER PRIMARY KEY AUTOINCREMENT,
        		crypto_curr TEXT,
        		curr TEXT,
        		exchange_id INTEGER,
        		date_time DATETIME DEFAULT CURRENT_TIMESTAMP,
        		buy DOUBLE,
        		sell DOUBLE,
        		last_hour_min DOUBLE,
        		last_day_min DOUBLE,
        		last_week_min DOUBLE,
        		last_month_min DOUBLE,
        		last_hour_max DOUBLE,
        		last_day_max DOUBLE,
        		last_week_max DOUBLE,
        		last_month_max DOUBLE
        		)"
    # Make Unique index
    db.execute "CREATE UNIQUE INDEX IF NOT EXISTS " +
    			"crypto_curr_id " +
    			"ON " +
    			"currents (crypto_curr, curr, exchange_id);"
    db.execute "CREATE TABLE IF NOT EXISTS histories(
				id INTEGER PRIMARY KEY AUTOINCREMENT,
        		crypto_curr TEXT,
        		curr TEXT,
        		exchange_id INTEGER,
        		date_time DATETIME DEFAULT CURRENT_TIMESTAMP,
        		buy DOUBLE,
        		sell DOUBLE
        		)"
    data = GetData.new.getResult
    for ex_data in data
    	if ex_data['success']
	    	last_min_max = calculateLastMinMax(ex_data)
	   	    query_current = "INSERT OR REPLACE INTO currents " +
	   	    				"(crypto_curr, curr, exchange_id, date_time, " +
	   	    				  "buy, sell, last_hour_min, last_day_min, last_week_min, " +
	   	    				  "last_month_min, last_hour_max, last_day_max, last_week_max, " +
	   	    				  "last_month_max)" +
	   	    				"VALUES ("+
							"\"" + ex_data['crypto_curr'] + "\", " +
							"\"" + ex_data['curr'] + "\", " +
							ex_data['exchange_id'].to_s + ", " +
							"\"" + Time.now.getutc.to_s + "\", " +
							ex_data['buy'].to_s + ", " + 
							ex_data['sell'].to_s + ", " + 
							last_min_max['last_hour_min'].to_s + ", " +
							last_min_max['last_day_min'].to_s + ", " +
							last_min_max['last_week_min'].to_s + ", " +
							last_min_max['last_month_min'].to_s + ", " +
							last_min_max['last_hour_max'].to_s + ", " +
							last_min_max['last_day_max'].to_s + ", " +
							last_min_max['last_week_max'].to_s + ", " +
							last_min_max['last_month_max'].to_s +
							")"
			query_history = "INSERT INTO "+
							"histories (crypto_curr, " +
									   "curr, " +
									   "exchange_id, " +
									   "date_time, " +
									   "buy, " +
									   "sell) VALUES (" +
							"\"" + ex_data['crypto_curr'] + "\", " +
							"\"" + ex_data['curr'] + "\", " +
							ex_data['exchange_id'].to_s + ", " +
							Time.now.getutc.to_s + ", " +
							ex_data['buy'].to_s + ", " + 
							ex_data['sell'].to_s +
							")"
			puts query_current
			puts query_history
			db.execute query_current
		else
			puts ex_data
		end
	end
rescue SQLite3::Exception => e
	puts "Exception"
	puts e
ensure
	db.close if db
end