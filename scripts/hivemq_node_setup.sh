HIVEMQ_VERSION=$1
STORAGE_ACCESS_KEY=$2
STORAGE_CONTAINER_NAME=$3
VM_INDEX=$4
DATABASE_SERVER=$5
DATABASE_USER=$6
DATABASE_PASSWORD=$7

sudo apt update -y
sudo apt install postgresql-client -y
export PGPASSWORD="${DATABASE_PASSWORD}"
sudo wget --content-disposition https://raw.githubusercontent.com/RyanDussiaume/connected-car-azure/main/scripts/postgresql_create.sql
sudo wget --content-disposition https://raw.githubusercontent.com/RyanDussiaume/connected-car-azure/main/scripts/permissions.sql
psql -h $DATABASE_SERVER -p 5432 -d postgres -U $DATABASE_USER -f postgresql_create.sql
psql -h $DATABASE_SERVER -p 5432 -d postgres -U $DATABASE_USER -f permissions.sql

EXTENSION_PROPERTIES_PATH="/opt/hivemq/extensions/hivemq-azure-cluster-discovery-extension/azDiscovery.properties"
HIVEMQ_DOWNLOAD_LINK="https://www.hivemq.com/releases/hivemq-${HIVEMQ_VERSION}.zip"

EXTENSION_DOWNLOAD_LINK="https://github.com/hivemq/hivemq-azure-cluster-discovery-extension/releases/download/1.1.0/hivemq-azure-cluster-discovery-extension-1.1.0.zip"

ESE_EXTENSION_PATH="/opt/hivemq/extensions/hivemq-enterprise-security-extension"

sudo apt-get update -y
sudo apt-get install -y openjdk-11-jdk
sudo apt-get -y install unzip

# Install HiveMQ 
cd /opt 
sudo wget --content-disposition $HIVEMQ_DOWNLOAD_LINK
sudo unzip "hivemq-${HIVEMQ_VERSION}.zip"
sudo ln -s "/opt/hivemq-${HIVEMQ_VERSION}" /opt/hivemq
sudo useradd -d /opt/hivemq hivemq
sudo chown -R hivemq:hivemq "/opt/hivemq-${HIVEMQ_VERSION}"
sudo chown -R hivemq:hivemq /opt/hivemq
cd /opt/hivemq
sudo chmod +x ./bin/run.sh
sudo cp /opt/hivemq/bin/init-script/hivemq.service /etc/systemd/system/hivemq.service

echo "<?xml version=\"1.0\"?>
<hivemq>

    <listeners>
        <tcp-listener>
            <port>1883</port>
            <bind-address>0.0.0.0</bind-address>
        </tcp-listener>
    </listeners>

    <cluster>
        <enabled>true</enabled>

        <transport>
            <tcp>
                <bind-address>0.0.0.0</bind-address>
                <bind-port>7800</bind-port>
            </tcp>
        </transport>

        <discovery>
            <extension/>
        </discovery>

    </cluster>

     <control-center>
        <enabled>true</enabled>
        <listeners>
            <http>
                <port>8080</port>
                <bind-address>0.0.0.0</bind-address>
            </http>
        </listeners>
    </control-center>

</hivemq>" | sudo tee /opt/hivemq/conf/config.xml

# Install extension

cd /opt/hivemq/extensions
sudo wget --content-disposition $EXTENSION_DOWNLOAD_LINK -O azure-extension.zip
sudo unzip azure-extension.zip 
echo "connection-string=${STORAGE_ACCESS_KEY}
container-name=hivemq-discovery
# An optional file-prefix for the Blob to create, which holds the cluster node information for the discovery. (default: hivemq-node)
# Do not omit this value if you reuse the specified container for other files.
file-prefix=hivemq-node-
# Timeout in seconds after which the created Blob will be deleted by other nodes, if it was not updated in time. (default: 360)
file-expiration=360
# Interval in seconds in which the Blob will be updated. Must be less than file-expiration. (default: 180)
update-interval=180" | sudo tee $EXTENSION_PROPERTIES_PATH

# Setup Security Extension

cd /opt/hivemq/extensions/hivemq-enterprise-security-extension/drivers/jdbc
sudo wget --content-disposition https://github.com/RyanDussiaume/connected-car-azure/raw/main/drivers/postgresql-42.5.1.jar

echo "<?xml version=\"1.0\" encoding=\"UTF-8\" ?>
<enterprise-security-extension
        xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\"
        xsi:noNamespaceSchemaLocation=\"enterprise-security-extension.xsd\"
        version=\"1\">
    <realms>
        <!-- a postgresql db-->
        <sql-realm>
            <name>postgres-backend</name>
            <enabled>true</enabled>
            <configuration>
                <db-type>POSTGRES</db-type>
                <db-name>postgres</db-name>
                <db-host>${DATABASE_SERVER}</db-host>
                <db-port>5432</db-port>
                <db-username>${DATABASE_USER}</db-username>
                <db-password>${DATABASE_PASSWORD}</db-password>
            </configuration>
        </sql-realm>

    </realms>

    <pipelines>
        <!-- secure access to the mqtt broker -->
        <listener-pipeline listener=\"ALL\">
            <authentication-preprocessors>
                <plain-preprocessor>
                    <transformations>
                        <transformation encoding=\"UTF8\">
                            <from>mqtt-clientid</from>
                            <to>authentication-key</to>
                        </transformation>
                        <transformation>
                            <from>mqtt-password</from>
                            <to>authentication-byte-secret</to>
                        </transformation>
                    </transformations>
                </plain-preprocessor>
            </authentication-preprocessors>
            <!-- authenticate over a sql db -->
            <sql-authentication-manager>
                <realm>postgres-backend</realm>
            </sql-authentication-manager>
            <!-- authorize over a sql db -->
            <sql-authorization-manager>
                <realm>postgres-backend</realm>
                <use-authorization-key>false</use-authorization-key>
                <use-authorization-role-key>true</use-authorization-role-key>
            </sql-authorization-manager>
        </listener-pipeline>
    </pipelines>
</enterprise-security-extension>" | sudo tee /opt/hivemq/extensions/hivemq-enterprise-security-extension/conf/enterprise-security-extension.xml
cd /opt/hivemq/extensions/hivemq-enterprise-security-extension
sudo rm DISABLED

# Start HiveMQ
sudo systemctl enable hivemq
sudo systemctl start hivemq
