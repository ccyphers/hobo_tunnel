module Sinatra
  module Limits
    module Helpers
    end

    def self.registered(app)
      app.helpers Limits::Helpers

      app.get '/new' do
        require_user
        params['tunnel_type'] ||= nil
        params['sport'] ||= nil
        params['dport'] ||= nil
        allowed_types = %w(local remote) 
        begin
          if params['sport'] && params['dport'] && allowed_types.include?(params['tunnel_type'])
            type = params['tunnel_type'] == 'local' ? 0 : 1
            params_tunnel
            current_user.limits.create(:tunnel_type => type, :ssh_port => params['sport'],
                                       :ssh_dport => params['dport'])

          end

        rescue => e
        end
      end

    end
  end
  register Limits
end 
