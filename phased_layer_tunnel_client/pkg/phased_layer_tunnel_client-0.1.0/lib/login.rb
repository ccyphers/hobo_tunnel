require 'rubygems'
require 'mechanize'
require 'json'
require 'platform_helpers'

MAX_HTTP_RETRIES=4
module CyberConnectAgent
  class Login
    @@agent = Mechanize.new

    def login
      field_map = { "user_session[email]" => @user, "user_session[password]" => @pass }
      if logged_in?
        logged_in = true
      else
        retry_ct = 0
        begin
          @@agent.post("#{@login_base_url}/user_sessions/create/", field_map)
          logged_in = logged_in?
          raise StandardError  unless logged_in
        rescue => e
          retry_ct +=1
          retry if retry_ct <= MAX_HTTP_RETRIES
          logged_in = false
        rescue Timeout::Error => e
          retry_ct +=1
          retry if retry_ct <= MAX_HTTP_RETRIES
          logged_in = false
        end
      end
      logged_in
    end

    def logged_in?
      begin
        res = JSON.parse(@@agent.get("#{@login_base_url}/user_sessions/logged_in").body)['logged_in']
p res.inspect
      rescue => e
        p e.inspect
        res = false
      end
      res
    end

    def sanity
      retry_ct = 0
      login_status = logged_in?
p 'sanity'
      unless login_status
        begin
          login_status = login
          raise StandardError unless login_status
        rescue => e
          retry_ct += 1
          retry if retry_ct <= MAX_HTTP_RETRIES
          login_status = false
        end
      end
      login_status
    end
  end
end
