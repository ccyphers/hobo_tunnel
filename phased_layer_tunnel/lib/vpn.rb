require 'sinatra/base'

module Sinatra
  module Cert
    module Helpers
    end

    def self.registered(app)
      app.helpers Cert::Helpers

      app.get '/cert' do
        require_user
        ssh_type = { 'local' => 0, 'remote' => 1}
        res = "<STATUS>deny</STATUS><CERT>-1</CERT>"
        params['conn_type'] ||= 'local'
        params['conn_port'] ||= '5900'
        if params['conn_type'] != '' && params['conn_port'] != ''
          begin
            limit = Limit.find(:first, :conditions => ["user_id = ? and ssh_type = ? and ssh_port = ?", 
                               current_user.id, ssh_type[params['conn_type']], params['conn_port'].to_i])
          rescue => e
            limit = nil
          end

          if limit
            tmp_file = "/tmp/#{current_user.email}_#{Token.provide}"
            begin
              `ssh-keygen -q -t rsa -b 2048 -N '' -f #{tmp_file}`
            rescue => e
              logger.warn("keygen error: #{e.inspect}")
            end
            if params.has_key?(:windows) then
              `puttygen #{tmp_file} -o #{tmp_file}.ppk`
              win_private = File.read("#{tmp_file}.ppk")
              res = "<STATUS>allow</STATUS><CERT>#{win_private}</CERT>"
            else
              #pub = File.read("#{tmp_file}.pub")
              pri = File.read(tmp_file)
              res = "<STATUS>allow</STATUS><CERT>#{pri}</CERT>"
            end
            `sudo /phased_layer_tunnel/bin/update_cert.sh #{current_user.email} #{tmp_file}.pub`
          else
            res = "<STATUS>deny</STATUS><CERT>-1</CERT>"
          end
        else
          res = "<STATUS>deny</STATUS><CERT>-1</CERT>"
        end
        res
      end

    end
  end
  register Cert
end 
