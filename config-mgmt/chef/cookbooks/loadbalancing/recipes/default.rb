# Make sure that we have haproxy and apache22 installed
%w[apache22 haproxy].each do |package|
    execute "install #{package} via pkgng" do
        command "pkg install -y #{package}"
        not_if "pkg info | grep ^#{package}-"
    end
end

# Templates are the preferred route.
# Don't do this in production..
file '/usr/local/etc/haproxy.conf' do
  owner 'nobody'
  group 'nobody'
  mode 0644
  action :create
  content <<-EOH
global
    maxconn 4096
    daemon

defaults
    retries 3
    option redispatch
    contimeout 5000
    clitimeout 50000
    srvtimeout 50000

listen MPISHI :8081
    mode http
    balance roundrobin
    option http-server-close
    timeout http-keep-alive 3000
    option httpchk GET /test.html
    stats enable
    stats uri /stats
    stats realm afnog\ loadbalancer
    stats auth afnog:success
    # Cookie called MPISHI injected into http connections
    cookie MPISHI insert
    server BACKENDSERVER1 127.0.0.1:80 cookie cookie-for-mpishi-server1 check
EOH

end

## Let's make sure that /etc/rc.conf has haproxy and apache enabled
# Service resource allows us to do service management easily
# Enable and start services.
# See http://docs.opscode.com/resource_service.html
%w[haproxy apache22].each do |service|
    service "#{service}" do
      action [ :enable, :restart ]
    end
end

# Create marker file for haproxy to detect
file '/usr/local/www/apache22/data/test.html' do
  owner 'root'
  group 'wheel'
  mode 0644
  action :create
  content "Server is OK..."
end
