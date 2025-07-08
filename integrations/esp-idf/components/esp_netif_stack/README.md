# ESP-NETIF stack component

This component is a direct dependency of ESP-NETIF and it defines a required dependency on lwIP.

## Purpose

Purpose of this component is to pull specific TCP/IP stack (lwIP) into the list of dependencies when using component ESP-NETIF.
By means of `esp*netif*stack` component, we can define these two
dependency scenarios:

1) Defines a required dependency on lwIP via this component (default)
2) In case a non-lwip build is required.

## Configure ESP-NETIF for building without lwIP

In order to use ESP-NETIF without lwIP (e.g. when using custom TCP/IP stack), follow these steps

* unselect `CONFIG*ESP*NETIF*TCPIP*LWIP` in `esp_netif` component configuration
* add a component `esp*netif*stack` to your private component paths
* register an empty component `idf*component*register()` in the component's CMakeLists.txt
