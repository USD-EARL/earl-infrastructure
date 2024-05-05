
# Notes

## Cross Compiling Sandcat for ARM
```bash
cd ./plugins/sandcat/gocat
env GOOS=linux GOARCH=arm go build -o armedcat32
```

## Contacting Caldera from EMUX-QEMU Guest
Below is a `traceroute` from within a shell on the QEMU guest (the emulated embedded system) to the Caldera container IP address on `mock_internet` the interface.
```
/ # traceroute 192.168.150.10
traceroute to 192.168.150.10 (192.168.150.10), 30 hops max, 38 byte packets
 1  192.168.100.1 (192.168.100.1)  1.664 ms  0.112 ms  0.042 ms
 2  192.168.150.9 (192.168.150.9)  81.646 ms  9.430 ms  192.168.150.10 (192.168.150.10)  42.284 ms
```
This shows that it is going through its `tap0` inteface (`192.168.100.1`) to the 
