FROM ubuntu:18.04

ARG USERNAME=vscode
ARG USER_UID=1000
ARG USER_GID=$USER_UID

SHELL ["/bin/bash", "-c"]

# Create the user
RUN groupadd --gid $USER_GID $USERNAME \
    && useradd --uid $USER_UID --gid $USER_GID -m $USERNAME \
    && sed -i 's/archive.ubuntu.com/mirrors.ustc.edu.cn/g' /etc/apt/sources.list \
    && sed -i 's/security.ubuntu.com/mirrors.ustc.edu.cn/g' /etc/apt/sources.list \
    && apt-get update \
    && apt-get install -y sudo git unzip curl wget python3 x11-xserver-utils\
    && echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME \
    && chmod 0440 /etc/sudoers.d/$USERNAME \
    && curl https://storage.googleapis.com/git-repo-downloads/repo > /usr/bin/repo \
    && chmod a+x /usr/bin/repo

USER $USERNAME
RUN cd \
    && wget https://dl.google.com/android/repository/platform-tools-latest-linux.zip \
    && unzip platform-tools-latest-linux.zip -d ~ \
    && rm platform-tools-latest-linux.zip \
    && echo $'\n\
# add Android SDK platform tools to path \n\
if [ -d "$HOME/platform-tools" ] ; then \n\
PATH="$HOME/platform-tools:$PATH" \n\
fi ' >> $HOME/.profile \
    && git clone https://github.com/akhilnarang/scripts \
    && cd scripts \
    && ./setup/android_build_env.sh

RUN git config --global user.email "meiweijia@gmail.com" \
    && git config --global user.name "meiwj"

WORKDIR /home/$USERNAME