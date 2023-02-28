HIVEMQ_VERSION=$1
STORAGE_ACCESS_KEY=$2
STORAGE_CONTAINER_NAME=$3
VM_INDEX=$4
DATABASE_SERVER=$5
DATABASE_USER=$6
DATABASE_PASSWORD=$7
GIT_USER=$8
GIT_PRIVATE_KEY=$9
GIT_BRANCH=$10

sudo apt update -y
sudo apt install git -y

cd ~
git clone https://${GIT_USER}:${GIT_PRIVATE_KEY}@github.com/RyanDussiaume/connected-car-poc.git

cd connected-car-poc
git checkout $GIT_BRANCH

sh ./hivemq_node_setup.sh $1 $2 $3 $4 $5 $6 $7