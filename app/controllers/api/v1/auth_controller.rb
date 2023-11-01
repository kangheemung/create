class Api::V1::AuthController < ApplicationController
     skip_before_action :verify_authenticity_token
  include JwtAuth
  def create
    user = User.find_by(email: params[:email])

    if user&.authenticate(params[:password])
      token = encode(user.id)
      render json: {status: 201, data: {name: user.name, email: user.email, token: token} }
    else
      render json: {status:400, error: 'Invalid username or password' }, status: :unauthorized
    end
  end
end
