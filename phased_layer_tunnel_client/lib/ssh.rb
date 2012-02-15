require 'net/ssh'

module SSH
  class Tunnel
    def initialize(params={})
      puts params.inspect
      params[:type] ||= 'local'
      params[:tunnel_pairs] ||= []
      @host = params[:host]
      @user = params[:user]
      @options = params[:options]
      @ssh = Net::SSH.start(@host, @user, @options)
      @gw_thread = nil
      @tunnel_pairs = params[:tunnel_pairs]
    end
    
    def start
      #puts @tunnel_pairs.inspect
      @tunnel_pairs.each { |pair|
        begin
          if pair['tunnel_type'] == 0
            @ssh.forward.local(pair['sport'].to_i, '127.0.0.1', pair['dport'].to_i)
          elsif pair['tunnel_type'] == 1
            @ssh.forward.remote(pair['sport'].to_i, '127.0.0.1', pair['dport'].to_i)
          end
        rescue => e
          puts "Error detected in tunnel: retrying: #{e.inspect}"
=begin
          if @type == 'local'
            @ssh.forward.cancel_local(@sport.to_i)
          elsif @type == 'remote'
            @ssh.forward.cancel_remote(@sport.to_i)
          end
=end
          sleep 2
          retry
        end
      }
      @ssh.loop { true }
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
