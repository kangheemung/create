class Api::V1::RelationshipsController < ApplicationController
   include JwtAuth
   before_action ->(request) { authenticate_request(request) }, only: [:create, :update, :destroy]
  

def create
  user_id = authenticate_request(request) # Assign the value returned by authenticate_request to user_id
  puts "================"
  puts user_id
  puts "================"
  
  if user_id.nil?
    render json: { status: 401, error: "Unauthorized" }
    return
  end
  
  token = encode(user_id) # Use the correct user_id here
  
  user = User.find_by(id: user_id, followed_id: params[:followed_id])
  
  if user.nil?
    render json: { status: 404, error: "User not found" }
    return
  end
  
  puts "====================="
  puts params
  puts "====================="
  
  follow = user.follow(relationships_params)
  
  if follow.save
    render json: { status: 201, data: follow, token: token }
  else
    render json: { status: 422, errors: follow.errors.full_messages }
  end
end

def destroy
  user_id = authenticate_request(request)
  
  if user_id.nil?
    render json: { status: 401, error: "Unauthorized" }
    return
  end
  
  relationship = Relationship.find(params[:id])
  user = relationship.followed
  
  authorize(user)
  
  if relationship.destroy
    render json: { status: 200, message: "Unfollowed successfully" }
  else
    render json: { status: 500, error: "Failed to unfollow user" }
  end
end
   private
  
    def relationships_params
      params.require(:relationship).permit(:follower_id, :followed_id)
    end
end
