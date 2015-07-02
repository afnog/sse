
# Happy path does not work on FreeBSD10
# package 'bind' { action :install }

# Shell exec exists... :)
execute 'install bind via pkgng' do
    command 'pkg install -y bind'
    not_if 'pkg info | grep ^bind-'
end


