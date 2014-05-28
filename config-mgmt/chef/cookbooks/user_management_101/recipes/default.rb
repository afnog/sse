
# You can look at the docs/code for the available attribs:
# - http://docs.opscode.com/resource_user.html
# - https://github.com/opscode/chef/blob/master/lib/chef/resource/user.rb
user 'gonfa' do
    uid 2014
    gid 0
    home '/home/gonfa'
    comment 'gonfa at afnog2014'
    shell '/bin/bash'
    supports  :manage_home => true
end

