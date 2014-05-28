
# Happy path does not work on FreeBSD10
# package 'bash' { action :install }

# Shell exec exists... :)
execute 'install bash via pkgng' do
    command 'pkg install -y bash'
    not_if 'pkg info | grep ^bash-'
end


