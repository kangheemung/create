class Api::V1::UsersController < ApplicationController
      include JwtAuth
      skip_before_action :jwt_auth, only: [:create]

    def create
        user=User.new(user_params)
          p"=============new======"
          p params
          p"==================="
          p "user variable"
          p user

        if user.save
          p"==============save====="
          p params
          p"==================="
          token = encode(user.id)
          render json: {status: 201, data: {name: user.name, email: user.email, token: token}}
        else
          p"error for user"
          p user.errors.full_messages
          render json: {status: 400,error: "users can't save and create"}
        end
    end
    def show 
        if user=User.find_by(id: params[:id])
            #確認完了
          token = encode(user.id)
          render json: {status: 201, data: {name: user.name, email: user.email,token: token}}
        else
          render json: {status: 400,error: "users can't save and create"}
        end
    end
    def update
      if user=User.find_by(id: params[:id])
        p"==============save====="
        p params
        p"==================="
        user.update(user_params)
        user.save
         token = encode(user.id)
        render json: {status: 201, data: {name: user.name, email: user.email,token: token}}
      else
        render json: {status: 400,error: "users can't update"}
      end
    end
      
    def follow
     p "============= check request header ========="
     p request.headers['Authorization'] 
     p"=============================="
       # jwt_authを呼び出して認証する
    jwt_auth
    if @current_user.nil?
    render json: { status: 401, error: "Unauthorized" }
      return
    end
    token = encode(@current_user.id) # 正しいuser_idを使用する
    user = User.find_by(id: params[:id])
    if user.nil?
      render json: { status: 404, error: "User not found" }
      return
    end
      if @current_user.following.include?(user)
        render json: { status: 400, error: "User is already being followed" }
      else
         @current_user.following << user
        render json: { status: 200, message: "Successfully followed user" }
      end
    end

    def unfollow
      p "============= check request header ========="
      p request.headers['Authorization'] 
      p"=============================="
       # jwt_authを呼び出して認証する
     jwt_auth
    if @current_user.nil?
    render json: { status: 401, error: "Unauthorized" }
      return
    end
      token = encode(@current_user.id) # 正しいuser_idを使用する
      user = User.find_by(id: params[:id])
    if user.nil?
      render json: { status: 404, error: "User not found" }
      return
    end
      if @current_user.following.include?(user)
        @current_user.following.delete(user)
        render json: { status: 200, message: "Successfully unfollowed user" }
      else
        render json: { status: 400, error: "User is not being followed" }
      end
    end
    
    private
     def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
     end
    
end
