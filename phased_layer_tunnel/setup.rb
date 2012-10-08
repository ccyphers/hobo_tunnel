#!/usr/bin/env /usr/local/ruby-1.9.3-p194/bin/ruby

def in_path(f)
  `which #{f}`.length > 0
end

def chroot_sanity
 `chroot --help` =~ /--userspec/
end

def sanity
  raise StandardError, "Must be run as root" unless ENV['USER'] == 'root'
  raise StandardError, "Upgrade coreutils in order for chroot to support --userspec" unless chroot_sanity
  %w(jk_init containerize_me).each { |dep| raise StandardError, "Could not find #{dep}" unless in_path dep } 
end

sanity
jail='/phased_layer_tunnel'
require 'fileutils'
`containerize_me --config /mnt/home_ext/l_bkup/svn/co/cyberconnect/containerize_me/templates/ubuntu_10.04_phased_layer_client.yml --jail #{jail}`

FileUtils.cp 'sshd_config', "#{jail}/etc/ssh/"

Dir.entries('bin').each { |i|
    next if File.directory? i
    FileUtils.cp "bin/#{i}", "#{jail}/bin"
}
