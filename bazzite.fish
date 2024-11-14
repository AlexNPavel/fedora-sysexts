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
try sudo -u alex podman pull ghcr.io/ublue-os/bazzite:stable
try sudo -u alex podman image prune -f

for SYSEXT in bees byobu gamemode htop iotop kdiskmark lact ncdu tuned-gui
	try sudo -u alex distrobox-enter  -n arch  --  bash -c "cd $SYSEXT && just build ghcr.io/ublue-os/bazzite:stable"
	try install -m 644 -o 0 -g 0 $SYSEXT/$SYSEXT*.raw /var/lib/extensions/$SYSEXT.raw
end
