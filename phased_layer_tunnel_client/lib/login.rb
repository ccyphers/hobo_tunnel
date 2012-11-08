require 'rubygems'
require 'curb'
require 'json'
require 'platform_helpers'

MAX_HTTP_RETRIES=4
module PhasedLayerTunnelAgent

  class Login
    attr_accessor :agent, :api_key
    def initialize(params={})
      params[:user] ||= ''
      params[:password] ||= ''
      params[:base_url] ||= ''
      params[:api_key] ||= ''
      @api_key = params[:api_key]
      @user = params[:user]
      @pass = params[:password]
      @base_url = params[:base_url]
      @agent = Curl::Easy.new
      @agent.enable_cookies = true
      @api_key = nil
    end

    def self.api_key(key)
      @api_key = key
    end
   
    def login
      if logged_in?
        logged_in = true
      else
        retry_ct = 0
        begin
          @agent.url="#{@base_url}/login"
          @agent.http_post(Curl::PostField.content('email', @user), Curl::PostField.content('password', @pass))
          logged_in = logged_in?
          raise StandardError  unless logged_in
        api_key if logged_in
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

    def api_key
      @agent.url="#{@base_url}/api_key"
      @agent.http_get
      Login.api_key(@agent.body_str)
    end

    def logged_in?
      begin
        @agent.url="#{@base_url}/logged_in?"
        @agent.http_get
        res = @agent.body_str.to_bool
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
