# Author: Cliff Cyphers
# License: GPLv3: http://www.gnu.org/licenses/gpl.html


module Net
  def self.test_proxy_connection(proxy = true, attempts = 2, to = 1, sleep = 0)
    if (Constants::E == "dev") then
      return ProcessMgt.has_client_ssh(:command_line_search => (Constants::CFG[:proxy][:ssh_user]), :exclude => (["_forward"]))
    end
    begin
      #agent = WWW::Mechanize.new
    rescue => e
      $logger.error("test_proxy_connection issue init Mechanize -- #{e.inspect}")
      return false
    end
    if proxy then
      begin
        #agent.set_proxy("127.0.0.1", Constants::LOCAL_PROXY_PORT))
      rescue => e
      end
    end
    begin
      #page = agent.get(Constants::BASE_URL)
    rescue Timeout::Error => e
      return false
    rescue => e
      return false
    end
    return true
  end
  def self.wait_for_connected(host, port, timeout = Constants::TUNNEL_TO)
    @init = Time.now.tv_sec
    $logger.debug("Waiting for forward tunnel to be established")
    begin
      (return false if ((Time.now.tv_sec - @init) >= timeout)
      raise(Errors::ConnectionTest) unless Net.is_connected?(port))
    rescue Errors::ConnectionTest
      sleep(0.6)
      retry
    rescue => e
      $logger.error("establishing connection: #{e.inspect}")
      raise(e)
    end
    true
  end
  def self.is_listening?(port)
    if (`netstat -an`.grep(/LISTEN/).grep(/tcp/i).grep(/#{port}/).nitems > 0) then
      return true
    else
      return false
    end
  end
  def self.init_connect(port)
    connected = false
    begin
      (conn = Net::Telnet.new("Host" => "127.0.0.1", "Port" => (port.to_i), "Telnetmode" => (false))
      conn.close
      connected = true)
    rescue => e
      $logger.error("Net.init_connect: #{e.inspect}")
    end
    connected
  end
  def self.wait_for_ssh(timeout, product)
    @init = Time.now.tv_sec
    begin
      (return false if ((Time.now.tv_sec - @init) >= timeout)
      if (product == "desktop") then
        has_tunnel = $priv_http_desktop.has_reverse_tunnel?
      else
        if (product == "file_manager") then
          has_tunnel = Net.is_listening?("#{Constants::FILE_UPLOAD_HTTP_PORT}".to_i)
          $logger.debug("wait_for_ssh: #{has_tunnel}")
        else
          if (product == "proxy") then
            forward_pairs = []
            (forward_pairs << { :forward_port => (Constants::LOCAL_PROXY_PORT), :desktop_port => (Constants::REMOTE_PROXY_PORT) })
            tunnel_cfg = ""
            forward_pairs.each do |pair|
              tunnel_cfg = (tunnel_cfg + "#{pair[:forward_port]}:127.0.0.1:#{pair[:desktop_port]}")
            end
            has_tunnel = ProcessMgt.is_running?(:command_line_search => (tunnel_cfg))
          end
        end
      end
      raise(Errors::ConnectionTest) unless has_tunnel)
    rescue Errors::ConnectionTest
      sleep(0.6)
      retry
    rescue => e
      $logger.error("Error testing ssh connection: #{e.inspect}")
      return false
    end
    true
  end
  def self.wait_for_disconnected(host, port, timeout = Constants::TUNNEL_TO)
    @init = Time.now.tv_sec
    $logger.debug("Disconnecting")
    begin
      (return false if ((Time.now.tv_sec - @init) >= timeout)
      raise(Errors::ConnectionTest) if Net.is_connected?(port))
    rescue Errors::ConnectionTest
      sleep(0.2)
      retry
    rescue => e
      $logger.error("Error disconnecting: #{e.inspect}")
      raise(e)
    end
    true
  end
  def tunnel_data?(port)
    # do nothing
  end
  def self.ssh_established?(host, port)
    netstat = `netstat -an`
    if (netstat.grep(/#{host}.#{port}/).grep(/ESTABLISHED/).nitems > 0) then
      return true
    else
      return false
    end
  end
  def self.is_connected?(port, ps_filter = nil)
    if ps_filter then
      if (Constants::PLATFORM == "windows") then
        ps = ProcessMgt.process_params(ps_filter)
        return false if (ps.grep(/#{port}/).nitems > 0)
      else
        ps = `ps -ef | grep -v grep | grep #{ps_filter} | grep -c #{port}`
        return false if ("#{ps.gsub(/\n/, "")}" == "1")
      end
    end
    netstat = `netstat -an`
    if (netstat.grep(/LISTEN/m).grep(/#{port}/).nitems > 0) then
      return true
    else
      return false
    end
  end
  def self.available_or_next(port)
    port = port.to_i
    if (Constants::PLATFORM == "windows") then
      ps_filter = "plink.exe"
    else
      ps_filter = "ssh"
    end
    if Net.is_connected?(port, ps_filter) then
      port = (port + 1)
      Net.available_or_next(port)
    else
      return port
    end
  end
end
