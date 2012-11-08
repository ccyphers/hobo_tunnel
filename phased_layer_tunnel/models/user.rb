class User < ActiveRecord::Base
  has_many :limits
  has_many :user_groups
  has_many :groups, :through => :user_groups
  validates_uniqueness_of :email
  validates_presence_of :email
  def enc_save
    self.password_salt = Token.provide
    self.crypted_password=self.crypted_password
    crypted_password = MD5.digest("#{self.password_salt}-#{self.crypted_password}")
    save
  end

  def self.create(params = {})
    u = User.new(:email => params[:email], :crypted_password => params[:crypted_password])
    u.enc_save
  end

  def validate
  end
end
