require 'sinatra/base'

module Sinatra
  module Cert
    module Helpers
    end

    def self.registered(app)
      app.helpers Cert::Helpers

      app.get '/tunnel_pairs' do
        require_user
        pairs=[]
        begin
          current_user.limits.each { |limit|
            pairs << {:tunnel_type => limit.ssh_type, :sport => limit.ssh_port, :dport => limit.ssh_dport}
          }
        rescue => e
          pairs = []
        end
        pairs.to_json
      end

      app.get '/cert' do
        require_user
        ssh_type = { 'local' => 0, 'remote' => 1}
        res = "<STATUS>deny</STATUS><CERT>-1</CERT>"
        params['conn_type'] ||= 'local'
        params['conn_port'] ||= '5900'

        if params['conn_type'] != '' && params['conn_port'] != ''
          begin
            limit = current_user.limits.first
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
            `sudo #{ENV['PHASED_LAYER_CHROOT']}/bin/update_cert.sh #{current_user.email} #{tmp_file}.pub`
            `sudo #{ENV['PHASED_LAYER_CHROOT']}/bin/update_cert_perms.sh #{current_user.email}`
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
