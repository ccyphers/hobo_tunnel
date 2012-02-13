require 'rubygems'
require 'curb'
require 'json'
require 'platform_helpers'

MAX_HTTP_RETRIES=4
module PhasedLayerTunnelAgent

  class Login
    def initialize(base_url, user, password)
      @user = user
      @pass = password
      @base_url=base_url
    end
    @@agent = Curl::Easy.new
    @@agent.enable_cookies = true
    def login
      if logged_in?
        logged_in = true
      else
        retry_ct = 0
        begin
          @@agent.url="#{@base_url}/login"
          @@agent.http_post(Curl::PostField.content('email', @user), Curl::PostField.content('password', @pass))
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
        @@agent.url="#{@base_url}/logged_in?"
        @@agent.http_get
        res = @@agent.body_str.to_bool
      rescue => e
        p e.inspect
        res = false
      end
      res
    end

    def sanity
      retry_ct = 0
      login_status = logged_in?
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
