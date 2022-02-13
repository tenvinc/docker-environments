FROM nvidia/cudagl:9.0-base-ubuntu16.04
#FROM osrf/ros:kinetic-desktop-full-xenial

# Run a full upgrade and install utilities for development.
RUN apt-get update && apt-get upgrade -y && apt-get install -y \
    mesa-utils \
    vim \
    build-essential gdb \
    cmake cmake-curses-gui \
    git \
    ssh \
 && rm -rf /var/lib/apt/lists/*

################################################ Install ROS ##########################################

# Register the ROS package sources.
ENV UBUNTU_RELEASE=xenial
RUN sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $UBUNTU_RELEASE main" > /etc/apt/sources.list.d/ros-latest.list'
RUN apt-key adv --keyserver 'hkp://keyserver.ubuntu.com:80' --recv-key C1CF6E31E6BADE8868B172B4F42ED6FBAB17C654

# Install ROS.
RUN apt-get update && apt-get install -y \
    ros-kinetic-ros-base \
 && rm -rf /var/lib/apt/lists/*

# # Upgrade Gazebo 7.
# RUN sh -c 'echo "deb http://packages.osrfoundation.org/gazebo/ubuntu-stable `lsb_release -cs` main" > /etc/apt/sources.list.d/gazebo-stable.list'
# RUN wget https://packages.osrfoundation.org/gazebo.key -O - | apt-key add -
# RUN apt-get update && apt-get install -y \
#     gazebo7 \
#  && rm -rf /var/lib/apt/lists/*

# Initialize rosdep
RUN rosdep init

# Only for nvidia-docker 1.0
LABEL com.nvidia.volumes.needed="nvidia_driver"
# ENV PATH /usr/local/nvidia/bin:${PATH}
# ENV LD_LIBRARY_PATH /usr/local/nvidia/lib:/usr/local/nvidia/lib64:${LD_LIBRARY_PATH}

# nvidia-container-runtime (nvidia-docker2)
ENV NVIDIA_VISIBLE_DEVICES \
   ${NVIDIA_VISIBLE_DEVICES:-all}
ENV NVIDIA_DRIVER_CAPABILITIES \
   ${NVIDIA_DRIVER_CAPABILITIES:+$NVIDIA_DRIVER_CAPABILITIES,}graphics

RUN apt update && apt install -y vim python-catkin-tools

# Add custom dependencies needed
RUN apt install -y ros-kinetic-angles ros-kinetic-tf ros-kinetic-laser-filters \
ros-kinetic-hector-gazebo-plugins ros-kinetic-controller-manager \
ros-kinetic-diagnostic-updater ros-kinetic-pcl-ros ros-kinetic-tf2-geometry-msgs ros-kinetic-eigen-conversions \
ros-kinetic-realtime-tools ros-kinetic-serial ros-kinetic-rviz ros-kinetic-bfl libopenblas-dev liblapack-dev \ 
libmove-base-msgs-dev libarmadillo-dev ros-kinetic-tf-conversions ros-kinetic-sparse-bundle-adjustment ros-kinetic-gazebo-ros-control \
ros-kinetic-joint-state-controller libprocps-dev python-ntplib ros-kinetic-twist-mux ros-kinetic-gmapping ros-kinetic-xacro \
ros-kinetic-joint-state-publisher ros-kinetic-robot-state-publisher ros-kinetic-rqt* ros-kinetic-teleop-twist-keyboard

RUN apt install -y libsdl-image1.2-dev && apt-get -y install libsdl-dev

RUN apt install -y ros-kinetic-desktop-full

# dependencies for building packages
RUN apt install python-rosdep python-rosinstall python-rosinstall-generator python-wstool build-essential -y

# initialize rosdep
RUN apt install python-rosdep -y
# RUN rosdep init
RUN rosdep update

# install catkin tools
RUN bash -c 'echo "deb http://packages.ros.org/ros/ubuntu `lsb_release -sc` main" > /etc/apt/sources.list.d/ros-latest.list'
RUN wget http://packages.ros.org/ros.key -O - | apt-key add -

RUN apt update && apt install python-catkin-tools -y

############################################## Setup Development environment ######################################
ENV QT_X11_NO_MITSHM 1

# Create users and groups.
ARG ROS_USER_ID=1000
ARG ROS_GROUP_ID=1000

RUN addgroup --gid $ROS_GROUP_ID tenvinc \
 && useradd --gid $ROS_GROUP_ID --uid $ROS_USER_ID -ms /bin/bash -p "$(openssl passwd -1 botsync)" -G root,sudo tenvinc \
 && echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers \
 && chown -R tenvinc:tenvinc /home/tenvinc

# Dependencies for tmux installation
ADD setup_tmux.sh /tmp/setup_tmux.sh
RUN chmod +x /tmp/setup_tmux.sh
ADD nvim-config /tmp/nvim-config
RUN chmod +x /tmp/nvim-config/setup_nvim.sh

USER tenvinc
# Source the ROS configuration.
RUN echo "source /opt/ros/kinetic/setup.bash" >> /home/tenvinc/.bashrc

# Setup tmux
RUN /tmp/setup_tmux.sh
RUN echo "export PATH=$HOME/local/tmux/bin:\$PATH" >> /home/tenvinc/.bashrc

# # Setup neovim
RUN /tmp/nvim-config/setup_nvim.sh

RUN rosdep update
WORKDIR /home/tenvinc
