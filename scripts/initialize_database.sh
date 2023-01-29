DATABASE_SERVER=$1
DATABASE_USER=$2
DATABASE_PASSWORD=$3

sudo apt update
sudo apt install postgresql-client
export PGPASSWORD="${DATABASE_PASSWORD}"
sudo wget --content-disposition https://raw.githubusercontent.com/RyanDussiaume/connected-car-azure/main/scripts/postgresql_create.sql
sudo wget --content-disposition https://raw.githubusercontent.com/RyanDussiaume/connected-car-azure/main/scripts/permissions.sql
psql -h $DATABASE_SERVER -p 5432 -d postgres -U $DATABASE_USER -f postgresql_create.sql
psql -h $DATABASE_SERVER -p 5432 -d postgres -U $DATABASE_USER -f permissions.sql