sudo docker build -t primebydesign/tensorflow-gpu-src .

# to run notebook
# sudo docker run -it primebydesign/tensorflow-gpu-src

# to run notebook
# sudo docker run -it primebydesign/tensorflow-gpu-src bash

# to run code
sudo docker stop tensorflow_container
sudo docker rm tensorflow_container

sudo docker network remove mynet123
sudo docker network create --subnet=172.18.0.2/16 mynet123

sudo docker run --net mynet123 --name tensorflow_container --ip 172.18.0.2 --runtime=nvidia --rm -i primebydesign/tensorflow-gpu-src bash -c "python ./code/main.py & tensorboard --logdir=./logs/tensorboard/" &
sleep 30s && sudo -H -u kiran x-www-browser http://172.18.0.2:6006 

