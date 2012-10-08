base = File.expand_path(File.dirname(__FILE__))
require base + '/../../lib/login'
describe PhasedLayerTunnelAgent::Login do
  it "does not autenticates a user without tokens" do
    login = PhasedLayerTunnelAgent::Login.new(:base_url => 'http://127.0.0.1:9292')
    login.logged_in?.should be_false
  end

  it "does not autenticates a user with an invalid password" do
    login = PhasedLayerTunnelAgent::Login.new(:base_url => 'http://127.0.0.1:9292', 
                                              :user => 'email@blah.com', :password => 'blah2')
    login.logged_in?.should be_false
  end

  it "does not autenticates a user with an invalid email" do
    login = PhasedLayerTunnelAgent::Login.new(:base_url => 'http://127.0.0.1:9292', 
                                              :user => 'email2@blah.com', :password => 'blah')
    login.logged_in?.should be_false
  end

  it "autenticates a user with tokens" do
    login = PhasedLayerTunnelAgent::Login.new(:base_url => 'http://127.0.0.1:9292', 
                                              :user => 'email@blah.com', :password => 'blah')
    login.login
    login.logged_in?.should be_true
  end

  it "should allow a shared session for client api" do
    login = PhasedLayerTunnelAgent::Login.new(:base_url => 'http://127.0.0.1:9292', 
                                              :user => 'email@blah.com', :password => 'blah')
    puts login.api_key
    login2 = PhasedLayerTunnelAgent::Login.new(:base_url => 'http://127.0.0.1:9292', 
                                               :api_key => login.api_key)
    login.login
    login2.login
    login.logged_in?.should be_true
    login2.logged_in?.should be_true
  end
end
