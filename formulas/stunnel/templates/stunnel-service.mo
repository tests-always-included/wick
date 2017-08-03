options = NO_SSLv3
setuid = stunnel4
setgid = stunnel4
chroot = /var/run/stunnel4
pid = /stunnel-{{NAME}}.pid

# Config for {{NAME}} written by the stunnelAddConfig function
[{{NAME}}]
accept = {{ACCEPT}}
connect = {{TARGET}}
cert = /etc/stunnel/ssl/{{NAME}}-cert.crt
CAfile = /etc/stunnel/ssl/{{NAME}}-ca.crt
{{#SERVER}}client = no{{/SERVER}}
{{^SERVER}}client = yes{{/SERVER}}
{{#VERIFY}}verify = {{VERIFY}}{{/VERIFY}}
{{#DELAY}}delay = yes{{/DELAY}}
