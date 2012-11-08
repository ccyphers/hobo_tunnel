require BASE + '/lib/auth'

class TunnelLimits < Sinatra::Base
  register Sinatra::Auth
  #register Sinatra::Limits

  configure do
    set(:chdir, BASE)
    set(:public_folder, (BASE + "/public"))
  end

  get '/delete' do
    require_user
    params['tunnel_type'] ||= nil
    params['sport'] ||= nil
    params['dport'] ||= nil
    allowed_types = %w(local remote) 
    allowed_types = %w(local remote) 
    begin
      if params['sport'] && params['dport'] && allowed_types.include?(params['tunnel_type'])
        type = params['tunnel_type'] == 'local' ? 0 : 1
        existing = Limit.find(:first, :conditions => {:ssh_type => 1, :ssh_port => params['sport'],
                                                      :ssh_dport => params['dport']})
        existing.delete if existing

      end
    rescue => e
    end
  end

  get '/new' do
    require_user
    params['tunnel_type'] ||= nil
    params['sport'] ||= nil
    params['dport'] ||= nil
    allowed_types = %w(local remote) 
    begin
      if params['sport'] && params['dport'] && allowed_types.include?(params['tunnel_type'])
        type = params['tunnel_type'] == 'local' ? 0 : 1
        existing = Limit.find(:first, :conditions => {:ssh_type => 1, :ssh_port => params['sport'],
                                                      :ssh_dport => params['dport']})

        current_user.limits.create(:ssh_type => 1, :ssh_port => params['sport'],
                                   :ssh_dport => params['dport']) unless existing

      end

    rescue => e
        puts "EEE: #{e.inspect}"
    end
  end

end
