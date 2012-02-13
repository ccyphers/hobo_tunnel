base = File.expand_path(File.dirname(__FILE__))

require 'highline/import'
require 'json'
require 'platform_helpers'
require  base + '/constants'
require  base + '/ssh'
require base + '/login'

class PhasedLayerTunnelClient < PhasedLayerTunnelAgent::Login
  VERSION = '0.1.0'
  def initialize(params={})
    params[:sport] ||= 0
    params[:dport] ||= 0
    @user = params[:user]
    @pass = params[:pass]
    @base_url = params[:base_url]
    @tunnel_type = params[:tunnel_type]
    @sport = params[:sport]
    @dport = params[:dport]
  end

  def private_cert
    res = {:status => false, :cert => nil}
    if sanity
      @@agent.url="#{@base_url}/cert?conn_type=#{@tunnel_type}&conn_port=#{@sport}"
      @@agent.perform
      t = @@agent.body_str
      res[:status] = t.scan(/<STATUS>(.*)<\/STATUS>/).pp == 'allow' ? true : false
      res[:cert] = t.scan(/<CERT>(.*)<\/CERT>/m).pp
    end
    res
  end

  def create_tunnel
    cert_res = private_cert
    if cert_res[:status]
      private_tmp = "#{Constants::TEMP}/#{Token.provide}_key"
      fd = File.open(private_tmp, 'w+')
      fd.puts cert_res[:cert]
      fd.close
      FileUtils.chmod 0600, private_tmp unless Constants::PLATFORM == 'dummies'
      ssh = SSH::Tunnel.new(:type => @tunnel_type, :host => '127.0.0.1', :sport => @sport, :dport => @dport,
                            :options=>{ :port => 2222, :passphrase=>"", :keys_only => true,
                            :keys=>[private_tmp]}, :user => @user)
      ssh.start 
    end
  end
end
