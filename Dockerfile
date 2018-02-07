FROM debian:sid as builder
RUN echo "deb     http://httpredir.debian.org/debian sid main"  >/etc/apt/sources.list
RUN echo "deb-src http://httpredir.debian.org/debian sid main" >>/etc/apt/sources.list

# build settings
ENV CFLAGS=-DTCL_UTF_MAX=6
ENV MAKEFLAGS=-j5
ENV TCL_VERSION=8.6.8
ENV TK_VERSION=8.6.8
ENV PY_BRANCH=2.7
ENV PY_VERSION=2.7.14+

# url
ENV TCL_URL=https://prdownloads.sourceforge.net/tcl/tcl${TCL_VERSION}-src.tar.gz
ENV TK_URL=https://prdownloads.sourceforge.net/tcl/tk${TK_VERSION}-src.tar.gz
ENV PY_URL=https://github.com/python/cpython/archive/${PY_BRANCH}.tar.gz

# checkinstall options
ENV PKG_RELEASE=0
ENV PKG_SUFFIX=custom
ENV PKG_MAINTAINER="yuuki0xff@gmail.com"

# install build dependencies.
ENV DEBIAN_FRONTEND=noninteractive
RUN apt update
RUN apt -y upgrade
RUN apt -y install build-essential checkinstall wget libx11-dev
RUN apt -y build-dep -y tcl tk python2.7

# download source codes.
RUN mkdir /build/
RUN wget "$TCL_URL" -O /build/tcl.tar.gz
RUN tar xvf /build/tcl.tar.gz -C /build/
RUN wget "$TK_URL" -O /build/tk.tar.gz
RUN tar xvf /build/tk.tar.gz -C /build/
RUN wget "$PY_URL" -O /build/cpython.tar.gz
RUN tar xvf /build/cpython.tar.gz -C /build/

# add helper script.
ADD chkinstall.sh /build/
RUN chmod +x /build/chkinstall.sh

# build TCL.
WORKDIR /build/tcl${TCL_VERSION}/unix
RUN pwd
RUN ./configure --enable-threads --enable-shared --enable-symbols --enable-64bit --enable-langinfo --enable-man-symlinks
RUN make clean
RUN make
RUN /build/chkinstall.sh tcl "$TCL_VERSION"

# build TK.
WORKDIR /build/tk${TK_VERSION}/unix
RUN ./configure --enable-threads --enable-shared --enable-symbols --enable-64bit --enable-man-symlinks
RUN make clean
RUN make
RUN /build/chkinstall.sh tk "$TK_VERSION"

# build Cpython.
WORKDIR /build/cpython-2.7
RUN ./configure --enable-shared --enable-optimizations --enable-ipv6 --enable-unicode=ucs4 --with-lto --with-signal-module --with-pth --with-wctype-functions --with-tcltk-includes=/usr/local/include/ --with-tcltk-libs=/usr/local/lib/
RUN make clean
RUN make
# checkinstallでは上手くインストールできない。
RUN make install


FROM debian:sid
COPY --from=builder /usr/local/ /usr_local
ADD https://github.com/cpbotha/nvpy/archive/master.tar.gz /srv/nvpy.tar.gz
RUN rm -rf /usr/local/ && mv /usr_local/ /usr/local/ && \
	ldconfig && \
	tar xf /srv/nvpy.tar.gz -C /srv/ && \
	echo "deb     http://httpredir.debian.org/debian sid main"  >/etc/apt/sources.list && \
	echo "deb-src http://httpredir.debian.org/debian sid main" >>/etc/apt/sources.list && \
	DEBIAN_FRONTEND=noninteractive apt update && \
	DEBIAN_FRONTEND=noninteractive apt -y upgrade && \
	DEBIAN_FRONTEND=noninteractive apt -y install tk8.6-blt2.5 ca-certificates

CMD ["python2", "/srv/nvpy-master/nvpy/nvpy.py"]

