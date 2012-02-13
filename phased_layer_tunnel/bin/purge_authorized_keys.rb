base = File.expand_path(File.dirname(__FILE__))
require "fileutils"
require 'find'



while true
#  `sudo #{base}/rm_certs.rb`

  Find.find('/home') { |entry|
    next unless entry =~ /authorized_keys$/
    delta = Time.now.tv_sec - File.stat(entry).ctime.tv_sec
    FileUtils.rm_f entry if delta > 30 
  }
  sleep 2
end

