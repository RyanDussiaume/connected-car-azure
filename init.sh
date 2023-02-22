GIT_USER=$1
GIT_PRIVATE_KEY=$2

sudo apt update -y
sudo apt install git -y

git clone https://${GIT_USER}:${GIT_PRIVATE_KEY}@github.com/RyanDussiaume/connected-car-poc.git

cd connected-car-poc
git checkout use-private-repo

sh ./test.sh