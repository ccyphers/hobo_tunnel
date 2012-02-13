require 'net/ssh'

module SSH
  class Tunnel
    def initialize(params={})
      params[:type] ||= 'local'
      @host = params[:host]
      @user = params[:user]
      @options = params[:options]
      @ssh = Net::SSH.start(@host, @user, @options)
      @gw_thread = nil
      @sport = params[:sport]
      @dport = params[:dport]
      @type = params[:type]
    end
    
    def start 
        begin
          if @type == 'local'
            @ssh.forward.local(@sport.to_i, '127.0.0.1', @dport.to_i)
            @ssh.loop { true }
          elsif @type == 'remote'
            @ssh.forward.remote(@dport.to_i, '127.0.0.1', @sport.to_i)
            @ssh.loop { true }
          end
        rescue => e
          puts "Error detected in tunnel: retrying"
          if @type == 'local'
            @ssh.forward.cancel_local(@sport.to_i)
          elsif @type == 'remote'
            @ssh.forward.cancel_remote(@sport.to_i)
          end
          retry
        end
    end
    def stop
      begin
        @ssh.forward.cancel_local(@sport.to_i)
        @gw_thread.kill
        @ssh.close
      rescue => e
        puts "EEEEEE: ssh stop\n\n#{e.inspect}\n\n"
      ensure 
        @gw_thread.kill
        @ssh.close  
      end
      
    end

  end
end
