Warden::Manager.before_failure { |env,opts| env['REQUEST_METHOD'] = "POST" }

Warden::Manager.serialize_into_session { |user| user }
Warden::Manager.serialize_from_session {|user| user }

Warden::Strategies.add(:my_strategy) do
  def valid?
    params['email'] ||= ''
    params['password'] ||= ''
    true
  end

  def authenticate!
    u=nil
    begin
      u = User.find_by_email(params['email'].strip)
      pass = MD5.digest("#{u.password_salt}-#{params['password']}")
      if u.crypted_password == pass
#        if u.single_access_token
#          u=nil
#        else
          u.single_access_token = Token.provide
          u.save
#        end
      else
        u = nil
      end
      u=nil unless u.crypted_password == pass
    rescue => e
      u=nil
    end
    u.nil? ? fail!("Couldn't log in") : success!(u)
  end
end

