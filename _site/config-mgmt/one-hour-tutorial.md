One hour tutorial on Ansible
============================

Materials by Brian Candler, NSRC.

Preparation
-----------

The demo will be with (say) 10 VMs. So to prepare for this:

* Create and start the VMs
* Ensure you can ssh to all machines as root (host key does not conflict,
  `/root/.ssh/authorized_keys` lets you in)
* Make a demo directory on the host you'll be running ansible on
* Inside it, make hosts.local

    ~~~
    [demo]
    vm1.ws.nsrc.org
    vm2.ws.nsrc.org
    vm3.ws.nsrc.org
    vm4.ws.nsrc.org
    vm5.ws.nsrc.org
    vm6.ws.nsrc.org
    vm7.ws.nsrc.org
    vm8.ws.nsrc.org
    vm9.ws.nsrc.org
    vm10.ws.nsrc.org
    ~~~

* Make group_vars/all

    ~~~
    ansible_ssh_user: root
    ~~~

* Test `ansible vm1.ws.nsrc.org -i hosts.local -m ping`

Presentation
------------

* Run through the intro-ansible.odp slide deck (30 mins)

Demonstration
-------------

* show the inventory (`cat hosts.local`)
* ansible vm1.ws.nsrc.org -i hosts.local -m ping
* ansible all -i hosts.local -m ping
* ansible vm1.ws.nsrc.org -i hosts.local -m setup | less
* create simple playbook to configure apt proxy

    ~~~
    ==> playbook.yml <==
    - hosts:
        - demo
      tasks:
        - name: configure to use proxy
          copy: src=99proxy dest=/etc/apt/apt.conf.d/99proxy owner=root mode=0644

    ==> 99proxy <==
    Acquire::http::Proxy "http://apt.ws.nsrc.org:3142/";
    ~~~

* ansible-playbook playbook.yml -i hosts.local --check --diff
* ansible-playbook playbook.yml -i hosts.local -l vm1.ws.nsrc.org
* run again to show it's idempotent
* obviously it would be far simpler to just manually change one host, but now run this against all hosts:
    * ansible-playbook playbook.yml -i hosts.local

* convert playbook to roles

    * mkdir -p roles/use_apt_cache/tasks

        ~~~
        ==> roles/use_apt_cache/tasks/main.yml <==
        - name: configure to use proxy
          copy: src=99proxy dest=/etc/apt/apt.conf.d/99proxy owner=root mode=0644

        ==> playbook.yml <==
        - hosts:
            - demo
          roles:
            - use_apt_cache
        ~~~

    * mkdir roles/use_apt_cache/files
    * mv 99proxy roles/use_apt_cache/files/
    * notice how the tasks and files are logically grouped together

* re-run to confirm it works the same
* create a new role for configuring /etc/hosts

    ~~~
    ==> roles/etc_hosts/tasks/main.yml <==
    - name: install /etc/hosts
      template: src=hosts dest=/etc/hosts owner=root mode=0644 backup=yes

    ==> roles/etc_hosts/templates/hosts <==
    127.0.0.1	localhost
    {{ansible_default_ipv4.address}}	{{inventory_hostname}} {{inventory_hostname_short}}

    # The following lines are desirable for IPv6 capable hosts
    ::1     ip6-localhost ip6-loopback
    fe00::0 ip6-localnet
    ff00::0 ip6-mcastprefix
    ff02::1 ip6-allnodes
    ff02::2 ip6-allrouters
    ~~~

* add tags so we can limit run to just one role

    ~~~
    ==> playbook.yml <==
    - hosts:
        - demo
      roles:
        - {role: use_apt_cache, tags: use_apt_cache}
        - {role: etc_hosts, tags: hosts}
    ~~~

* run it on one host
    * ansible-playbook playbook.yml -i hosts.local -l vm1.ws.nsrc.org -t hosts
* Login to machine and note that the old /etc/hosts was destroyed!
* add `backup=yes` to the task, and then run against the other hosts
    * ansible-playbook playbook.yml -i hosts.local -t hosts

Conclusion
----------

* point to sample playbooks/roles at <https://github.com/ansible/ansible-examples>
* for a huge example see <https://github.com/edx/configuration/wiki/edX-Ubuntu-12.04-64-bit-Installation>
