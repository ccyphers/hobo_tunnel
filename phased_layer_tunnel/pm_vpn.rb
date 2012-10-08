
class PoorMansVPN < Sinatra::Base
  register Sinatra::Auth
  register Sinatra::Cert
#  register Sinatra::Limits

  configure do
    set(:chdir, BASE)
    set(:public_folder, (BASE + "/public"))
  end

  get("/") do
    require_user
    erb :index
  end

end
