#!/usr/bin/env bash

# If systemd is working:
if /bin/systemctl -a > /dev/null
then
  # exit.
  exit 0
# If systemd isn't working:
else
  # Fire it up and detach.
  /usr/bin/nohup /bin/systemd --system --unit=basic.target > /root/$(hostname -f).systemd.log 2>&1 &

  # Disable the ssh service, since we're running sshd in the foreground
  # to keep our container running.
  /bin/systemctl disable ssh
fi
