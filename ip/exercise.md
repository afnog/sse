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

Start a capture (e.g. 1000 packets), look at the traffic and analyse it.

Look out for:

* Wireless (802.11)
* ARP
* DNS
* UDP (Skype/VPN/unusual)

Investigate the properties of the packets by expanding layers at the bottom.

Investigate a DNS packet. What host is being looked up, by who and why?

What's the source MAC address of your incoming packets? And destination of
your outgoing packets? Why?

If you find something interesting/unusual, send a pcap file to the intructor.

### Learn how to filter captures

* What filter would you put in the capture box to select HTTP traffic?
* How would you select HTTP traffic in the packet list view (main screen)?

### Reading TCP Stream

* Start capturing and then browse a website.
* Right click on an HTTP packet and view TCP stream.
* Look at the HTTP headers: what do they mean?

### Drawing Graphs

* Start a capture.
* Set up charting with an unfiltered graph and a filtered one (e.g. http traffic).
* Try downloading something and see what happens.
* What speed do you get? What causes the dips in the transfer rate?

## Network Security

### Check for open ports

```
sudo pkg install nmap
```

Find out which hosts are up on our LAN, and the whole of AfNOG.

Check for open ports:

* On your virtual server
* On your laptop
* On a real server under your control

What do the different states mean? open/closed/filtered

What can you do with these ports?

Try connecting to one:

* SSH port with `ssh`
* HTTP port with `fetch`
* DNS port with `dig`

