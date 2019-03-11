
##################################
# Make sure we're running as root
##################################

if (( $EUID != 0 )); then
    echo "Please make sure you're running this as root."
    echo "try again with: 'sudo bash setup.sh'"
    exit
fi

##################################
# Install CUDA
# Source: https://medium.com/@zhanwenchen/install-cuda-and-cudnn-for-tensorflow-gpu-on-ubuntu-79306e4ac04e
###################################

# get graphics driver
yes Y | sudo apt-get install nvidia-384 nvidia-modprobe

# download cuda 9.0
if [ ! -f ./cuda_9.0.176_384.81_linux-run ]; then
    wget https://developer.nvidia.com/compute/cuda/9.0/Prod/local_installers/cuda_9.0.176_384.81_linux-run
fi

# extract downloaded cuda stuff
chmod +x cuda_9.0.176_384.81_linux-run
./cuda_9.0.176_384.81_linux-run --extract=$HOME
sudo $HOME/cuda-linux.9.0.176-22781540.run

# cleanup extracted cuda installers
sudo rm $HOME/cuda-linux.9.0.176-22781540.run
sudo rm ./cuda_9.0.176_384.81_linux-run

#OPTIONAL INSTALL CUDA SAMPLES... I'VE LEFT THIS OUT.
#sudo ./cuda-samples.9.0.176-22781540-linux.run

##################################
# Install docker
# Source: https://docs.docker.com/install/linux/docker-ce/ubuntu/#extra-steps-for-aufs
##################################

# remove older docker versions
yes Y | sudo apt-get remove docker docker-engine docker.io

# update repo (not sure if this is needed but can't do any harm)
yes Y | sudo apt-get update

# install packages to allow apt to use a repository over HTTPS
yes Y | sudo apt-get install \
    apt-transport-https \
    ca-certificates \
    curl \
    software-properties-common

# download private key so you can access docker server
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

# verify key
yes Y | sudo apt-key fingerprint 0EBFCD88

# add repository for docker
yes Y | sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"

# Install Docker 

yes Y | sudo apt-get update
yes Y | sudo apt-get install docker-ce

##################################
# Now let's install NVidea Docker
# Source: https://github.com/NVIDIA/nvidia-docker
##################################

# If you have nvidia-docker 1.0 installed: we need to remove it and all existing GPU containers
docker volume ls -q -f driver=nvidia-docker | xargs -r -I{} -n1 docker ps -q -a -f volume={} | xargs -r docker rm -f
yes Y | sudo apt-get purge -y nvidia-docker

# Add the package repositories
curl -s -L https://nvidia.github.io/nvidia-docker/gpgkey | \
  sudo apt-key add -
distribution=$(. /etc/os-release;echo $ID$VERSION_ID)

curl -s -L https://nvidia.github.io/nvidia-docker/$distribution/nvidia-docker.list | \
  sudo tee /etc/apt/sources.list.d/nvidia-docker.list
sudo apt-get update

# Install nvidia-docker2 and reload the Docker daemon configuration
sudo apt-get install -y nvidia-docker2:2.0.3+docker18.06.2-1
sudo pkill -SIGHUP dockerd

# Let's remove any existing running images before we start. Otherwise we can end up with problems where the volume is already being used.
#   If a volume is already in use you'll get a shitty error message: 
#   docker: Error response from daemon: OCI runtime create failed: ... 
sudo docker rmi $(sudo  docker images -q) -f

# Test nvidia-smi with the latest official CUDA image
sudo docker run --runtime=nvidia --rm nvidia/cuda:9.0-base nvidia-smi

sudo rm *.deb

echo "Reboot your system before attempting to run."