
##################################
# Make sure we're running as root
##################################

if (( $EUID != 0 )); then
    echo "Please make sure you're running this as root."
    echo "try again with: 'sudo bash setup.sh'"
    exit
fi

# remove graphics driver
yes Y | sudo apt-get remove nvidia-384 nvidia-modprobe

# remove docker
yes Y | sudo apt-get remove docker docker-engine docker.io docker-ce

# install packages to allow apt to use a repository over HTTPS
yes Y | sudo apt-get uninstall \
    apt-transport-https \
    ca-certificates \
    curl \
    software-properties-common

# If you have nvidia-docker 1.0 installed: we need to remove it and all existing GPU containers
docker volume ls -q -f driver=nvidia-docker | xargs -r -I{} -n1 docker ps -q -a -f volume={} | xargs -r docker rm -f
yes Y | sudo apt-get purge -y nvidia-docker

# Install nvidia-docker2 and reload the Docker daemon configuration
sudo apt-get remove -y nvidia-docker2

// cleanup
yes Y | sudo apt autoremove