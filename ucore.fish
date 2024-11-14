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
try sudo -u alex podman pull ghcr.io/ublue-os/ucore:stable
try sudo -u alex podman image prune -f

for SYSEXT in btop htop fish iotop
	try sudo -u alex distrobox-enter  -n arch  --  bash -c "cd $SYSEXT && just build ghcr.io/ublue-os/ucore:stable"
	try tailscale file cp $SYSEXT/$SYSEXT*.raw hetzner:
end
