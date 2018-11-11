sudo docker build -t primebydesign/tensorflow-gpu-src .

# to run notebook
# sudo docker run -it primebydesign/tensorflow-gpu-src

# to run notebook
# sudo docker run -it primebydesign/tensorflow-gpu-src bash

# to run code
sudo docker run --runtime=nvidia -it --rm primebydesign/tensorflow-gpu-src python ./code/main.py
