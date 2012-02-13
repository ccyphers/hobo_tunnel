#!/usr/bin/env ruby
require 'find'
require 'fileutils'
Find.find('/home') { |entry|
  next unless entry =~ /authorized_keys$/
  delta = Time.now.tv_sec - File.stat(entry).ctime.tv_sec
  FileUtils.rm_f entry if delta > 30 
}

