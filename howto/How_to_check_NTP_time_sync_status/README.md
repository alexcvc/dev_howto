### How to check ntp status and system time sync

1 obtain the offset as shown below:

```shell
ntp_offset=$(ntpq -pn | \
     /usr/bin/awk 'BEGIN { offset=1000 } $1 ~ /\*/ { offset=$9 } END { print offset }')
```

2. Get result $? variable:

```shell
echo $ntp_offset
+0.152
```

Summary:

1. System clock is synchronized when: ntp_offset < 1000

2. System clock unsynchronised when: ntp_offset >= 1000

