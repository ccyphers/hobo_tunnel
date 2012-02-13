require 'fileutils'
module Constants
  if RUBY_PLATFORM =~ /darwin/ || RUBY_PLATFORM =~ /linux/
    TEMP = '/tmp'
    PLATFORM = 'unix_like'
  elsif RUBY_PLATFORM =~ /mswin/i || RUBY_PLATFORM =~ /mingw/
    FileUtils.mkdir_p "#{ENV['APPDATA']}/temp" unless File.exists?("#{ENV['APPDATA']}/temp")
    TEMP = "#{ENV['APPDATA']}/temp"
    PLATFORM = 'dummies'
  end

  TUNNEL_TYPES = %w(local remote shared_screen)
end
