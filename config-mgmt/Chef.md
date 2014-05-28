# Chef

## Introduction
From wikipedia
```
Chef is a configuration management tool written in Ruby and Erlang. It uses a pure-Ruby,
domain-specific language (DSL) for writing system configuration "recipes". Chef is 
used to streamline the task of configuring & maintaining a company's servers.....
```

What it really means:
* Allows you provision large number of servers very quickly.
* Allows you to have a consistent setup across your fleet.
* Be utilised as a component of a continuous integration pipeline. 
* Can be tied to autoscaling and autohealing workflows to let you sleep better at night.

## Glossary (from https://wiki.opscode.com/display/chef/Glossary):
* Cookbook
```
Chef cookbooks are packages for code used to configure some aspect of a system.
```
* DSL
```
Programming or specification language dedicated to a specific problem domain.
Chef makes use of meta-programming features in Ruby to create a simple DSL for
writing Recipe, Role, and Metadata files.
```
* Recipe
```
A recipe is a Ruby DSL configuration file that you write to encapsulate
resources that should be configured by Chef.
```

* JSON
```
JavaScript Object Notation is a lightweight data format that is easy to read
and write. All the APIs used in Chef are driven by JSON data.
```
* Role
```
A role describes a set of functionality for nodes through recipes and
attributes.
```
* Ruby
```
Ruby is an object-oriented programming language. Chef is written in Ruby and
uses a number of Ruby DSLs for writing Recipe, Role, Metadata as code.
```
* Node
```
A node is a system that is configured by Chef.
```


## Installation
FreeBSD
* Install Ruby, Rubygems
```sh
$ sudo pkg install ruby ruby19-gems wget
```

* Install the Chef Gem
```sh
$ sudo gem install ohai chef --no-rdoc --no-ri
```

## Usage
We are going to use the simpler chef-solo mode. It will give you a quick
introduction without the complications of running a chef-server. Once you are
comfortable with solo-mode, take a look at hosted mode.

To use chef solo, you need to:
1. Create a recipe which contains the desired state.
2. Reference the recipe[s] created in a runlist
3. Create a solo file.
4. Run chef-solo

### Simplest example: Create a file
So let's create a file similar to resolv.conf that will live in your tmp dir.
* Must contain the stanza
```
nameserver 196.200.223.10
```
* File mode (permissions): 644
* Owned by the user:group: afnog:afnog
* File should be located at: /tmp/resolv.conf


#### Create a recipe
* Create a recipe in a chef directory under your home
```sh
$ cd $HOME

$ mkdir -p $HOME/chef/cookbooks/resolv_conf_afnog_tmp/recipes/

$ echo """

file '/tmp/resolv.conf' do
  owner 'afnog'
  group 'afnog'
  mode 0644
  action :create
  content 'nameserver 196.200.223.10'
end
""" > $HOME/chef/cookbooks/resolv_conf_afnog_tmp/recipes/default.rb
```

* Create a runbook for your recipe[s]
```sh
$ echo '
{
  "run_list": [ "recipe[resolv_conf_afnog_tmp]" ]
}' > $HOME/chef/node.json
```

* Create the solo file.
```sh
$ echo """
  file_cache_path '$HOME/chef'
  cookbook_path '$HOME/chef/cookbooks'
  json_attribs '$HOME/chef/node.json'
""" > $HOME/chef/solo.rb
```

* Let's bake everything!
```sh
$ sudo chef-solo -c ~/chef/solo.rb
```

* And the results should be
```
Starting Chef Client, version 11.12.4
Compiling Cookbooks...
Converging 1 resources
Recipe: resolv_conf_afnog_tmp::default
  * file[/tmp/resolv.conf] action create
    - create new file /tmp/resolv.conf
    - update content in file /tmp/resolv.conf from none to ee51f2
        --- /tmp/resolv.conf    2014-05-28 12:26:02.000000000 +0300
        +++ /tmp/.resolv.conf20140528-80310-1dk48xp 2014-05-28 12:26:02.000000000 +0300
        @@ -1 +1,2 @@
        +nameserver 196.200.223.10
    - change mode from '' to '0644'
    - change owner from '' to 'afnog'
    - change group from '' to 'afnog'


Running handlers:
Running handlers complete

Chef Client finished, 1/1 resources updated in 2.418799259 seconds

```

* Now attempt to corrupt the file, delete it or change it and rerun chef-solo.
Chef will revert the file into the expected stated
```sh
# Accidentaly delete a file! File is recreated
$ cat /tmp/resolv.conf
$ rm /tmp/resolv.conf
$ sudo chef-solo -c $HOME/chef/solo.rb
$ cat /tmp/resolv.conf

# Uninteded modifications get reverted.
$ cat /tmp/resolv.conf
$ echo 1234 > /tmp/resolv.conf
$ sudo chef-solo -c $HOME/chef/solo.rb
$ cat /tmp/resolv.conf
```

## User management
```sh
$ mkdir -p $HOME/chef/cookbooks/user_management_101/recipes

$ echo """
# You can look at the docs/code for the available attribs:
# - http://docs.opscode.com/resource_user.html
# - https://github.com/opscode/chef/blob/master/lib/chef/resource/user.rb
user 'gonfa' do
    uid 2014
    gid 4102
    home '/home/gonfa'
    comment 'gonfa @ afnog'
    shell '/bin/bash'
    supports  :manage_home => true
end
""" > $HOME/chef/cookbooks/user_management_101/recipes/default.rb


# Now let's have some sed fun. Text replacement w/out using an editor
# Compare the file before and after by running cat
# This should be run once and only once!
$ cat $HOME/chef/node.json
$ sed -ie 's/\]$/, "recipe[user_management_101]" ]/' $HOME/chef/node.json
$ cat $HOME/chef/node.json


# Run chef-solo
$ sudo chef-solo -c $HOME/chef/solo.rb
```


## Lets install a package
```sh
$ mkdir -p $HOME/chef/cookbooks/install_bash/recipes

$ echo """
# Happy path does not work on FreeBSD10
# package 'bash' { action :install }

# Luckily, we can shell exec
execute 'install bash via pkgng' do
    command 'pkg install bash'
    not_if 'pkg info | grep "^bash-"'
end

""" > $HOME/chef/cookbooks/install_bash/recipes/default.rb


# Now let's have some sed fun. Text replacement w/out using an editor
# Compare the file before and after by running cat
# This should be run once and only once!
$ cat $HOME/chef/node.json
$ sed -ie 's/\]$/, "recipe[install_bash]" ]/' $HOME/chef/node.json
$ cat $HOME/chef/node.json


# Run chef-solo
$ sudo chef-solo -c $HOME/chef/solo.rb
```

## Lets install more security packages
```sh
$ mkdir -p $HOME/chef/cookbooks/install_security_packages/recipes

# Run an editor
$ ee  $HOME/chef/cookbooks/install_security_packages/recipes/default.rb
```

* Paste the following into your edit
```
# Install the following packages: nmap, tshark, stunnel and tcpdump.

%w[nmap tshark stunnel tcpdump].each do |package|
    execute "install #{package} via pkgng" do
        command "pkg install #{package}"
        not_if "pkg info | grep ^#{package}-"
    end
end
```

* Adjust the runlist for the node
``` sh
# Now let's have some sed fun. Text replacement w/out using an editor
# This should be run once and only once!
$ cat $HOME/chef/node.json
$ sed -ie 's/\]$/, "recipe[install_security_packages]" ]/' $HOME/chef/node.json
$ cat $HOME/chef/node.json


# Run chef-solo
$ sudo chef-solo -c $HOME/chef/solo.rb
```
* You should now have tshark, nmap, tcpdump and stunnel installed


### Load balancing. Yup, we can do it!

