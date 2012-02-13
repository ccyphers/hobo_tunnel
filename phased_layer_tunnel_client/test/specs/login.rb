base = File.expand_path(File.dirname(__FILE__))
require base + '/../../lib/login'
describe PhasedLayerTunnelAgent::Login do
  it "does not autenticates a user without tokens" do
    login = PhasedLayerTunnelAgent::Login.new('http://127.0.0.1:9292', '', '')
    login.logged_in?.should be_false
  end

  it "does not autenticates a user with an invalid password" do
    login = PhasedLayerTunnelAgent::Login.new('http://127.0.0.1:9292', 'email@blah.com', 'blah2')
    login.logged_in?.should be_false
  end

  it "does not autenticates a user with an invalid email" do
    login = PhasedLayerTunnelAgent::Login.new('http://127.0.0.1:9292', 'email2@blah.com', 'blah')
    login.logged_in?.should be_false
  end

  it "autenticates a user with tokens" do
    login = PhasedLayerTunnelAgent::Login.new('http://127.0.0.1:9292', 'email@blah.com', 'blah')
    login.login
    login.logged_in?.should be_true
  end

end
