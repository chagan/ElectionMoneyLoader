# If starting fresh 
# Download most recent version of Election data
# echo('Downloading latest election data')
# curl -o IL_Elections_latest.zip 'http://il-elections.s3.amazonaws.com/IL_Elections_latest.zip'

# Unzip and overwrite if there's already a version
echo Unziping the election file
unzip -o IL_Elections_latest.zip

# Startup postgres, drop the database if it exists and then create a new one
echo Resetting the database
dropdb electionmoney
createdb electionmoney

# Convert tsv to csv
echo Converting tsv to csv
python tsv2csv.py -i IL_Elections*/*/*.tsv

# Load all the csv's to the postgres database we created earlier
echo Loading Candidates, Committees and Officers to postgres 
csvsql --db postgresql://chris@localhost:5432/electionmoney --insert IL_Elections*/*.csv -v

echo Loading Expenditures, Receipts and Reports to postgres
csvsql --db postgresql://chris@localhost:5432/electionmoney --insert IL_Elections*/*/*.csv -v