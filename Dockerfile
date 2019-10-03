FROM debian:stretch

RUN \
    apt-get update && apt-get install -y --no-install-recommends \
        gcc \
        git \
        libc6-dev \
        make \
    && rm -rf /var/lib/apt/lists/*

RUN cd /root && git clone git://git.kernel.org/pub/scm/linux/kernel/git/morgan/libcap.git

RUN cd /root/libcap && make

FROM scratch
COPY --from=0 /root/libcap/progs/capsh /bin/
COPY --from=0 /root/libcap/progs/getcap /bin/
COPY --from=0 /root/libcap/progs/setcap /bin/

CMD ["/bin/capsh", "--print"]
