###############################################################################
# Parameters
###############################################################################

ARG prefix=/opt
ARG qt_prefix=/p

###############################################################################
# Base Image
###############################################################################

FROM quay.io/sharpreflections/centos7-build-base as base

###############################################################################
# Builder Image
###############################################################################

FROM base as builder

RUN yum -y upgrade \
 && yum -y install \
# our build dependencies \
        xorg-x11-server-utils \
        libX11-devel \
        libSM-devel \
        libxml2-devel \
        libGL-devel \
        libGLU-devel \
        libibverbs-devel \
        freetype-devel \
        which \
        libXtst \
        libXext-devel \
        autoconf \
        automake \
        libtool \
        patch \
        bison \
        flex \
        tcl \
	rpm-build \
# we need some basic fonts and manpath for the mklvars.sh script \
        urw-fonts \
        man \
# clang, gcc and svn \
        cmake3 \
        devtoolset-8 \
        libatomic \
        libgomp \
        llvm-toolset-7 \
        libomp-devel \
        sclo-subversion19 \
        distcc-server \
# Misc (developer) tools and xvfb for QTest \
        strace \
        valgrind \
        bc \
        joe \
        vim \
        nano \
        mc \
        psmisc \
        xorg-x11-server-Xvfb \
        libXcomposite \
	wget \
        python2-pip \
# For Squish \
        tigervnc-server \
        nc \
 && yum -y clean all --enablerepo='*' \
 \
# cmake comes as cmake3. use cmake for consistency in build scripts \
 && ln -s /usr/bin/cmake3 /usr/bin/cmake \
 && ln -s /usr/bin/ctest3 /usr/bin/ctest \

# install numpy and scipy python packages
 && pip install numpy==1.16.6 --trusted-host pypi.org --trusted-host pypi.python.org --trusted-host files.pythonhosted.org \
 && pip install scipy==1.2.0 --trusted-host pypi.org --trusted-host pypi.python.org --trusted-host files.pythonhosted.org \
 && pip3 install numpy \
 && pip3 install scipy
###############################################################################
# Final Image
###############################################################################

FROM builder

WORKDIR /

COPY --from=quay.io/sharpreflections/centos7-build-protobuf ${prefix} ${prefix}
COPY --from=quay.io/sharpreflections/centos7-build-qt ${qt_prefix} ${qt_prefix}
