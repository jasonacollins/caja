set -x
docker pull mcr.microsoft.com/azure-sql-edge:latest

docker stop ${DB_CONTAINER} 
docker rm ${DB_CONTAINER}
docker run --platform=linux/arm64 -e 'ACCEPT_EULA=Y' -e "SA_PASSWORD=$PASSWORD" \
           -p 1433:1433 --name ${DB_CONTAINER} \
           -d mcr.microsoft.com/azure-sql-edge:latest
sleep 20  # Give SQL Server more time to initialize properly

# Use the mssql-tools image with platform emulation to run sqlcmd against your database container
docker run --rm --platform=linux/amd64 --network=host mcr.microsoft.com/mssql-tools \
  /opt/mssql-tools/bin/sqlcmd -S localhost,1433 -U SA -P "$PASSWORD" \
  -Q "CREATE DATABASE $DATABASE"