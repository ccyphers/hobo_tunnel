class User < ActiveRecord::Base
  Encoding.default_internal='ASCII-8BIT'
  Encoding.default_external='ASCII-8BIT'

  has_many :limits
  def env_save
    self.password_salt = Token.provide
    self.crypted_password = MD5.digest("#{self.password_salt}-#{self.crypted_password}")
    self.save
  end

  def self.create(params = {})
    u = User.new(:email => params[:email], :crypted_password => params[:crypted_password])
    u.env_save
  end

  def validate
  end
  
end
