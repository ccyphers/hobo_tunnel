class User < ActiveRecord::Base
  has_many :user_groups
  has_many :groups, :through => :user_groups
  has_many :user_limits
  has_many :limits, :through => :user_limits

  # FIXME - add socket connection to mail server and query for user
  # for proper validation
  validates :email, :uniqueness => true, :presence => true,
            :format => { :with => %r(\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*),
                         :message => "please provide a valid email format."}
  before_destroy :group_references

  def self.delete_by_email(email=0)
    user = User.find(:first, :conditions =>{:email => email})
    user.user_groups.delete_all
    user.destroy
    user
  end

  def enc_save
    self.password_salt = Token.provide
    self.crypted_password ||= Token.provide
    crypted_password = MD5.digest("#{self.password_salt}-#{self.crypted_password}")
    save
  end

  def self.create(params = {})
    params[:crypted_password] ||= Token.provide
    u = User.new
    u.email = params[:email]
    u.crypted_password = params[:crypted_password]
    u.enc_save
    u
  end

  def validate
  end

  private
  def group_references
    if UserGroup.find(:first, :conditions => {:user_id => self.id})
      errors.add(:user, "User belongs to at least one group.  Remove the user from the groups before continuing")
      return false
    else
      return true
    end
  end
end
