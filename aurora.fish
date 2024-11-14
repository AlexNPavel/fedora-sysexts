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
try sudo -u apavel podman pull ghcr.io/ublue-os/aurora-dx:stable
try sudo -u apavel podman image prune -f

for SYSEXT in bees btop byobu kdiskmark lact ncdu ocp-sso-token tuned-gui
	try sudo -u apavel distrobox-enter  -n arch  --  bash -c "cd $SYSEXT && just build ghcr.io/ublue-os/aurora-dx:stable"
	try install -m 644 -o 0 -g 0 $SYSEXT/$SYSEXT*.raw /var/lib/extensions/$SYSEXT.raw
end

try systemctl restart systemd-sysext
