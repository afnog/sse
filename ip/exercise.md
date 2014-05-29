# Internet Protocols

Chris Wilson, [Aptivate](http://www.aptivate.org/), AfNOG 2014

## Questions to get you thinking

* What is an IP address?
* What is a port?
* What is ARP?
* Source and Destination Ports
* Ports used by common services
* What is Wireshark?

## Investigations

### Install Wireshark on your computer

Some versions [already downloaded](http://mini1.sse.ws.afnog.org/~inst/wireshark/),
otherwise go to http://www.wireshark.org/download.html.

### Capture some traffic

Run a capture for 10 seconds, look at the traffic and analyse it.

Look out for:

* Wireless (802.11)
* ARP
* DNS
* UDP

If you find something interesting/unusual, send a pcap file to the intructor.

### Learn how to filter captures

* What filter would you put in the capture box to select HTTP traffic?

* How would you select HTTP traffic in the packet list view (main screen)?

## Network Security

### Check for open ports

```
sudo pkg install nmap
```

* On your virtual server
* On your laptop
* On a real server under your control

What can you do with these ports?

### Check for open ports

