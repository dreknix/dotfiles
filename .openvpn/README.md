# OpenVPN

``` console
sudo apt install openvpn
```

## Start OpenVPN Client

``` console
sudo openvpn --config target.ovpn
```

## Importing into NetworkManager

Using OpenVPN with NetworkManager. First install OpenVPN plugin for
NetworkManager.

``` console
sudo apt install network-manager-openvpn network-manager-openvpn-gnome
```

Import the OpenVPN configuration with `VPN Settings` > `Add` > `Import from
files`. Or via the cli:

``` console
nmcli connection import type openvpn file target.ovpn
```
