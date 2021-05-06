# Use an official Python runtime as a parent image
FROM ubuntu:20.04

# Set the working directory to /var/src
WORKDIR /var/src

# Copy the current directory contents into the container at /var/src
ADD . /var/src

#basic update
RUN apt-get update 
RUN apt-get upgrade
RUN apt-get install -y software-properties-common

#Locale
RUN apt-get install -y language-pack-ja-base language-pack-ja
RUN update-locale LANG=ja_JP.UTF8

#gcc
RUN apt-get install -y gcc

#vim
RUN apt-get install -y vim

#latest sqlite
RUN apt-get install -y sqlite3

#mysql
RUN apt-get install -y mysql-server
RUN apt-get install -y libmysqlclient-dev

# prepare for installing python
RUN apt-get install -y wget build-essential libreadline-gplv2-dev libncursesw5-dev libssl-dev libsqlite3-dev tk-dev libgdbm-dev libc6-dev libbz2-dev libffi-dev zlib1g-dev 

# set python environment
RUN wget https://www.python.org/ftp/python/3.9.4/Python-3.9.4.tgz \
 && tar xzf Python-3.9.4.tgz \
 && cd Python-3.9.4 \
 && ./configure \
 --with-ensurepip \
 --enable-shared \
 --enable-ipv6 \
 --prefix=/usr/local/python3.9 \
 --enable-optimizations \
 && make -j4 \
 && make altinstall
ENV LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/python3.9/lib
ENV PATH=$PATH:/usr/local/python3.9/bin
RUN ln -sf /usr/local/python3.9/bin/python3.9 /usr/bin/python3
RUN ln -sf /usr/local/python3.9/bin/pip3.9 /usr/bin/pip3
RUN ln -sf /usr/share/pyshared/lsb_release.py /usr/local/python3.9/lib/python3.9/site-packages/lsb_release.py
RUN pip3 install --upgrade pip

# Install any needed packages specified in requirements.txt
RUN pip3 install -r requirements.txt

#to path
#RUN echo 'LD_LIBRARY_PATH="$LD_LIBRARY_PATH:/usr/local/python3.9/lib"' >> ~/.bashrc
#RUN echo 'PATH="$PATH:/usr/local/python3.9/bin"' >> ~/.bashrc
#RUN source ~/.bashrc

# Make port 80 available to the world outside this container
EXPOSE 80
