# PXE
Some config stuff for PXE.
- Network is assumed to have a DHCP server already
- dnsmasq augments existing DHCP with PXE stuff
- Some HTTP server can be used for file transfers, if needed. I'm using darkhttpd because it's easy to use (`darkhttpd .` serves the current directory)
