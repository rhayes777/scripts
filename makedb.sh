
psql -U postgres -p 5432 -c "CREATE DATABASE $1;"
psql -U postgres -p 5432 -c "CREATE USER $1 WITH PASSWORD '$2';"
psql -U postgres -p 5432 -c "GRANT CONNECT ON DATABASE $1 TO $1;"
psql -U postgres -p 5432 -d $1 -c "ALTER DEFAULT PRIVILEGES FOR USER $1 IN SCHEMA public GRANT SELECT, INSERT, UPDATE, DELETE ON TABLES TO $1;"
psql -U postgres -p 5432 -d $1 -c "GRANT USAGE ON schema public TO '$1'"
psql -U postgres -p 5432 -d $1 -c "GRANT ALL ON SCHEMA public TO postgres;"
psql -U postgres -p 5432 -d $1 -c "GRANT ALL ON SCHEMA public TO public;"
