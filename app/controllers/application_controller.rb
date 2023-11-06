class ApplicationController < ActionController::API
     include JwtAuth
     before_action :jwt_auth
end
