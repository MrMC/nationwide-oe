#!/bin/sh

(
  /bin/sleep 30; \
  /usr/sbin/ntpdate pool.ntp.org; \
)&
