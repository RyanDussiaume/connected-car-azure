sudo apt update
sudo apt install postgresql-client
export PGPASSWORD='EpK@YAFFiCXjm9k*tR6@i-gR'
sudo wget --content-disposition https://raw.githubusercontent.com/RyanDussiaume/connected-car-azure/main/scripts/postgresql_create.sql
psql -h ese-database-hfk5pvdcwshho.postgres.database.azure.com -p 5432 -d postgres -U ryan -f postgresql_create.sql