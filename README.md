A simple docker container with static binaries for:
- [capsh](http://man7.org/linux/man-pages/man1/capsh.1.html)
- [getcap](http://man7.org/linux/man-pages/man8/getcap.8.html)
- [setcap](http://man7.org/linux/man-pages/man8/setcap.8.html)

Available on Docker Hub: https://hub.docker.com/r/scionproto/docker-caps

This makes it easy to work with capabilities in docker containers. E.g. see the effect of docker's [--cap-add/--cap-drop](https://docs.docker.com/engine/reference/run/#runtime-privilege-and-linux-capabilities) flags:
```
$ docker run --rm -it --cap-add chown --cap-drop net_raw scionproto/docker-caps
Current: = cap_chown,cap_dac_override,cap_fowner,cap_fsetid,cap_kill,cap_setgid,cap_setuid,cap_setpcap,cap_net_bind_service,cap_sys_chroot,cap_mknod,cap_audit_write,cap_setfcap+eip
Bounding set =cap_chown,cap_dac_override,cap_fowner,cap_fsetid,cap_kill,cap_setgid,cap_setuid,cap_setpcap,cap_net_bind_service,cap_sys_chroot,cap_mknod,cap_audit_write,cap_setfcap
Ambient set =
Securebits: 00/0x0/1'b0
 secure-noroot: no (unlocked)
 secure-no-suid-fixup: no (unlocked)
 secure-keep-caps: no (unlocked)
 secure-no-ambient-raise: no (unlocked)
uid=0(???)
gid=0(???)
groups=
```

More importantly, it makes it easy to set capabilities on binaries during docker builds. E.g.:
```
FROM scionproto/docker-caps as caps

FROM prom/blackbox_exporter
COPY --from=caps /bin/setcap /bin
RUN setcap cap_net_raw+ep /bin/blackbox_exporter && rm /bin/setcap
```
