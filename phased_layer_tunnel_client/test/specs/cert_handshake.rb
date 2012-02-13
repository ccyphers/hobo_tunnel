base = File.expand_path(File.dirname(__FILE__))
require base + '/../../lib/phased_layer_tunnel_client'
describe PhasedLayerTunnelClient do
  it "does not get a cert without valid tokens" do
    client = PhasedLayerTunnelClient.new(:user => 'email@blah.com2', :pass => 'blah', 
                                         :tunnel_type => 'local', :sport => 5900, :dport => 5900,
                                         :base_url => 'http://localhost:9292')
    res=client.private_cert
    res[:status].should be_false
    res[:cert].should be_nil
  end

  it "gets a cert wit valid tokens" do
    client = PhasedLayerTunnelClient.new(:user => 'email@blah.com', :pass => 'blah', 
                                         :tunnel_type => 'local', :sport => 5900, :dport => 5900,
                                         :base_url => 'http://localhost:9292')
    res=client.private_cert
    res[:status].should be_true
    res[:cert].should =~ /^-----BEGIN RSA PRIVATE KEY-----/
  end



end
