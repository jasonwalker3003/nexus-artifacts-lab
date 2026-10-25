#!/bin/bash
# install-nexus.sh: installs Sonatype Nexus Repository as a systemd service.
# Run it on the server as root, e.g. from your PC: ssh jason@IP 'sudo bash -s' < install-nexus.sh
set -euo pipefail

URL=https://download.sonatype.com/nexus/3/latest-linux-x86_64.tar.gz

if [ "$(id -u)" -ne 0 ]; then
  echo "Run this as root (sudo)."
  exit 2
fi

mkdir -p /opt/sonatype

# Nexus must not run as root, and Sonatype says its account needs a real shell.
id nexus > /dev/null 2>&1 || useradd --system --home-dir /opt/sonatype --shell /bin/bash nexus

curl -fsSL "$URL" | tar -xz -C /opt/sonatype
versions=(/opt/sonatype/nexus-3.*)
ln -sfn "${versions[0]}" /opt/sonatype/nexus
chown -R nexus:nexus /opt/sonatype

cat > /etc/systemd/system/nexus.service <<'EOF'
[Unit]
Description=nexus service
After=network.target

[Service]
Type=forking
LimitNOFILE=65536
ExecStart=/opt/sonatype/nexus/bin/nexus start
ExecStop=/opt/sonatype/nexus/bin/nexus stop
User=nexus
Restart=on-abort
TimeoutSec=600

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl enable --now nexus
echo "Nexus is starting. It answers on port 8081 after a minute or two."
