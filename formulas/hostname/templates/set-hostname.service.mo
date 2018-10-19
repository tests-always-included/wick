[Unit]
Description="Set the hostname."
Wants=network-online.target
After=network-online.target

[Service]
Type=oneshot
ExecStart=/usr/local/bin/set-hostname '{{DESIRED}}' --iface="{{IFACE}}"

[Install]
WantedBy=multi-user.target
