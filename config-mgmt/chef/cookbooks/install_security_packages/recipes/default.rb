# Install the following packages: nmap, tshark, stunnel and tcpdump.

%w[nmap tshark stunnel tcpdump].each do |package|
    execute "install #{package} via pkgng" do
        command "pkg install -y #{package}"
        not_if "pkg info #{package}"
    end
end
