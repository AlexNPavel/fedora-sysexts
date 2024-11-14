#!/bin/fish

function try
  if ! $argv
    echo "ERROR ($argv)"
    exit 1
  end
end

if not fish_is_root_user
	echo "Run script as root"
	exit 1
end

git clean -dfX

for SYSEXT in bees byobu htop iotop lact ncdu rocm-smi tuned-gui
	try sudo -u alex distrobox-enter  -n arch  --  bash -c "cd $SYSEXT && just build ghcr.io/ublue-os/bazzite:stable"
	try install -m 644 -o 0 -g 0 $SYSEXT/$SYSEXT*.raw /var/lib/extensions/$SYSEXT.raw
end

try systemctl restart systemd-sysext
