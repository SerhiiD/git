FROM centos as builder

WORKDIR /workdir

RUN yum --enablerepo=base clean metadata \
    && yum -y update \
    && yum -y install wget \
    dh-autoreconf curl-devel expat-devel gettext-devel openssl-devel perl-devel zlib-devel \
    && yum -y group install "Development Tools" \
    && yum clean all

RUN wget https://mirrors.edge.kernel.org/pub/software/scm/git/git-2.20.1.tar.gz

RUN tar -zxf git-2.20.1.tar.gz \
    && cd git-2.20.1 && make configure \
    && ./configure --prefix=/workdir/git \
    && make all \
    && make install


FROM centos:centos6

COPY --from=builder /workdir/git /workdir/git

CMD [ "/workdir/git/bin/git", "--version" ]
