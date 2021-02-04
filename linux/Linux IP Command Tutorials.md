# Linux IP Command Tutorials

The `ip` command is a Linux net-tool for system and network administrations. Many older Linux distributions are still using `ifconfig` for network configurations, however, `ifconfig` has a limited range of capabilities compared to `ip` command.

### `ip` Command Usage Template

```
ip [OPTION] OBJECT {COMMAND | help}
```

The subcommand `OBJECT` stands for some network objects, like:

1.  link (l): used to display and modify network interface;
2.  address (addr/a): used to display and modify protocol address (IPv4/IPv6);
3.  route (r): used to display and alter the routing table;
4.  neigh (n): used to display and manipulate neighbor objects

use `ip help` for more information.

#### Get Network Interface Information

To see link-layer information for all available devices, use the command:

```
ip link show
```

To see statistics for all network interfaces, use:

```
ip -s link
```

#### Modify Network Interface Status

If you want to bring a network interface up/down, use:

```
ip link set [interface] up/down
```

Modify the transmit queue length for speeding up or slowing down interfaces to reflect your need and hardware possibilities.

```
ip link set txqueuelen [number] dev [interface]
```

Set the mtu (maximum transfer unit) to improve network performace:

```
ip link set mtu [number] dev [interface]
```

