
FROM ubuntu:16.04


#设置镜像源
#COPY ./sources.list  /etc/apt/sources.list.2

#设置中文
ENV LANG C.UTF-8

WORKDIR /root
VOLUME /root


RUN apt-get update \
        && apt-get install -y  vim lrzsz curl net-tools inetutils-ping zip \
        && apt-get install -y  mesa-opencl-icd ocl-icd-opencl-dev software-properties-common \
        && add-apt-repository ppa:longsleep/golang-backports -y \
        && apt update \
        && apt install -y golang-go gcc git bzr jq pkg-config mesa-opencl-icd ocl-icd-opencl-dev \
        # 用完包管理器后安排打扫卫生可以显著的减少镜像大小
        && apt-get clean \
        && apt-get autoclean \
        && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

#使用swap增加内存编译go程序
#dd if=/dev/zero of=/root/swapfile bs=1M count=1024 && mkswap /root/swapfile && swapon /root/swapfile \
#swapoff /root/swapfile && rm -rf /root/swapfile
RUN git clone https://github.com/filecoin-project/lotus.git \
        && cd lotus/ && make clean && make all && make install

CMD ["/bin/bash"]
