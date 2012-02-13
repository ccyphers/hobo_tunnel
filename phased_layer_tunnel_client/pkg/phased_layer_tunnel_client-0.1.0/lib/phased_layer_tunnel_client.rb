base = File.expand_path(File.dirname(__FILE__))

require 'mechanize'
require 'highline/import'
require 'json'
require 'platform_helpers'
require  base + '/ssh'
require base + '/login'

class PhasedLayerTunnelClient < CyberConnectAgent::Login
  VERSION = '0.1.0'
  def initialize(params={})
    @user = params[:user]
    @pass = params[:pass]
    @login_base_url = params[:login_base_url]
    @service_base_url = params[:service_base_url]
    @tunnel_type = params[:tunnel_type]
    @sport = params[:sport]
    @dport = params[:dport]
  end

  def private_cert
    res = {:status => false, :cert => nil}
    if sanity
      t = @@agent.get("#{@service_base_url}/poor_mans_vpn/cert/?conn_type=local&conn_port=10001").body
      res[:status] = t.scan(/<STATUS>(.*)<\/STATUS>/).to_s == 'allow' ? true : false
      res[:cert] = t.scan(/<CERT>(.*)<\/CERT>/m).to_s
    end
    res
  end

  def create_tunnel
    cert_res = private_cert
p cert_res
    if cert_res[:status]
      private_tmp = "/tmp/#{Token.provide}_key"
      fd = File.open(private_tmp, 'w+')
      fd.puts cert_res[:cert]
      fd.close
      FileUtils.chmod 0600, private_tmp

      ssh = SSH::Tunnel.new(:type => @tunnel_type, :host => '127.0.0.1', :sport => @sport, :dport => @dport,
                            :options=>{ :port => 2222, :passphrase=>"", :keys_only => true,
                            :keys=>[private_tmp]}, :user => @user)

      if ['local', 'remote'].include?(@tunnel_type)
        ssh.start
      end
    end
  end
end
