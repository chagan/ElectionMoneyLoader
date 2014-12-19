# If starting fresh 
# Download most recent version of Election data
echo Downloading latest election data
#curl -o IL_Elections_latest.zip 'http://il-elections.s3.amazonaws.com/IL_Elections_latest.zip'

# Unzip and overwrite if there's already a version
echo Unziping the election file
#unzip -o IL_Elections_latest.zip

# Startup postgres, drop the database if it exists and then create a new one
echo Resetting the database
dropdb electionmoney
createdb electionmoney

# Convert tsv to csv, then concatenate
echo Converting tsv to csv
#python tsv2csv.py -i IL_Elections*/*/*.tsv

echo Concatenate csv for Reports, Expenditures and Receipts
#csvstack IL_Elections*/Reports/*.csv > Reports.csv
#csvstack IL_Elections*/Expenditures/*.csv > Expenditures.csv
#csvstack IL_Elections*/Receipts/*.csv > Receipts.csv

# Load all the csv's to the postgres database we created earlier
echo Loading Candidates, Committees and Officers to postgres 
head -n 5000 IL_Elections*/Candidates.csv | csvsql --db postgresql://chris@localhost:5432/electionmoney -v --no-constraints --table candidates
head -n 5000 IL_Elections*/Committees.csv | csvsql --db postgresql://chris@localhost:5432/electionmoney -v --no-constraints --table committees
head -n 5000 IL_Elections*/Officers.csv | csvsql --db postgresql://chris@localhost:5432/electionmoney -v --no-constraints --table officers

psql electionmoney -c "COPY candidates FROM '`pwd`/IL_Elections_2014-12-17/Candidates.csv' DELIMITER ',' CSV HEADER;"
psql electionmoney -c "COPY committees FROM '`pwd`/IL_Elections_2014-12-17/Committees.csv' DELIMITER ',' CSV HEADER;"
psql electionmoney -c "COPY officers FROM '`pwd`/IL_Elections_2014-12-17/Officers.csv' DELIMITER ',' CSV HEADER;"

echo Loading Reports, Receipts and Expenditures to postgres 
head -n 5000 Expenditures.csv | csvsql --db postgresql://chris@localhost:5432/electionmoney -v --no-constraints --table expenditures
head -n 5000 Receipts.csv | csvsql --db postgresql://chris@localhost:5432/electionmoney -v --no-constraints --table receipts
head -n 5000 Reports.csv | csvsql --db postgresql://chris@localhost:5432/electionmoney -v --no-constraints --table reports

psql electionmoney -c "COPY reports FROM '`pwd`/reports.csv' DELIMITER ',' CSV HEADER;"
psql electionmoney -c "COPY receipts FROM '`pwd`/receipts.csv' DELIMITER ',' CSV HEADER;"
psql electionmoney -c "COPY expenditures FROM '`pwd`/expenditures.csv' DELIMITER ',' CSV HEADER (ERROR_LOGGING, ERROR_LOGGING_SKIP_BAD_ROWS);"