sudo docker build -t primebydesign/tensorflow-gpu-src .


# Instructions: 

# When running this open another terminal and type "docker ps". This will give you a list of running containers. 
# find this container and type docker inspect <containerID> (or name works too)
# this will show you a load of stuff about the container. Find it's IP address and use this in place of the stuff in brackets in the output:
#  example output: http://(758e8f6237f3 or 127.0.0.1):8888/?token=5d0c0db567b3413f4ca33c403dd5e2c4eaef2d4c4cff1ef7
#
# In the example above you'd replace (758e8f6237f3 or 127.0.0.1) with the container's ip address and open that in a browser.
#
 
# to run notebook
sudo docker run --runtime=nvidia -it --rm primebydesign/tensorflow-gpu-src
