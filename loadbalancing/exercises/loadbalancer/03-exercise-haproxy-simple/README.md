Synopsis
--------
Testing Layer4 and Layer7 loadbalancers

Howto
-----
Layer4:
======

Open a terminal and execute:
```sh
 $ cd layer4
 $ ls
```

Then for each of the sub directories (example: 01-simple-rr-lb)
* Change dir to it.
* Read the configs and shell scripts.
* Lookup the config directives used online.
* Test with your browser

Incantation:
```sh
 $ cd subdir
 $ sh runme.sh &
 $ sh test.sh
 # Play with your browser
 # When you are done, kill the lb
 $ bg
 $ kill %1
```

 


Layer7:
======

Open a terminal and execute:
```sh
 $ cd layer7
 $ ls
```

Then for each of the sub directories (example: 01-simple-rr-lb)
* Change dir to it.
* Read the configs and shell scripts.
* Lookup the config directives used online.
* Test with your browser

Incantation:
```sh
 $ cd subdir
 $ sh runme.sh &
 $ sh test.sh
 # Play with your browser
 # When you are done, kill the lb
 $ bg
 $ kill %1
```
