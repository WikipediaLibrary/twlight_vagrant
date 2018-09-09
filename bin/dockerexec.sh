#!/usr/bin/env bash

# Fire up systemd and detach.
#/usr/bin/nohup /bin/systemd --system --unit=basic.target > /root/$(hostname -f).systemd.log 2>&1 &
#service dbus start
/bin/systemd --system --unit=basic.target &

# Wait for dbus to come up.
#dbus=$(/bin/systemctl status dbus)
#until [ $dbus ]
#do
#  echo "waiting for dbus."
#  sleep 1
#done

# Start the ssh service.
#/bin/systemctl start ssh
#/bin/systemctl start ssh || /usr/sbin/sshd
/usr/sbin/sshd

# Keep our container running.
trap : TERM INT
sleep infinity & wait
