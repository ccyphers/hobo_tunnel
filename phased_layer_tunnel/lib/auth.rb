require 'sinatra/base'
module Sinatra
  module Auth
    module Helpers
      def current_user
        env['warden'].user
      end

      def require_api_key(token)
        valid = false
        if current_user
          valid = current_user.single_access_token == token ? true : false
        end
        redirect '/login' unless valid
      end

      def require_user
        unless current_user
          env['rack.session']['redirect']=request.path
          redirect '/login' 
        end
      end

      def logged_in?
        if current_user
          return true
        else
          return false
        end
      end

    end

    def self.registered(app)
      app.helpers Auth::Helpers

      app.get '/api_key' do
        require_user
        current_user.single_access_token
      end

      app.get '/valid_key' do
        require_api_key
        true
      end

      app.get '/login/?' do
        erb :login
      end

      app.get '/logged_in?' do
        logged_in?.to_json
      end

      app.post '/login/?' do
        env['warden'].authenticate!

        path = env['rack.session'].has_key?('redirect') ?  env['rack.session']['redirect'] : '/'
        redirect path
        #redirect "/"
      end

      app.get '/logout/?' do
        if current_user
          current_user.single_access_token = nil
          current_user.save
        end
        env['warden'].logout
        redirect '/'
      end

      app.post '/unauthenticated/?' do
        status 410
        "Could not login"
      end
    end
  end
  register Auth
end 
