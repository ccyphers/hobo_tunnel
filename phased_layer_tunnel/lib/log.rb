class Log
  @fd = File.open('/tmp/t.log', 'w+')
  def self.put(msg)
    @fd.puts msg
    @fd.flush
  end
end

