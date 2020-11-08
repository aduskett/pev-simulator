# pev-simulator
Emulate a plugin electric vehicle using risev2g and docker

# Note
Docker must have ipv6 enabled in /etc/docker/daemon.json
An example config is below:
```
{
  "ipv6": true,
  "fixed-cidr-v6": "2001:db8:1::/64"
}
```
