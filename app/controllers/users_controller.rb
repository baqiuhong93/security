class UsersController < ApplicationController

  def permissions
    user = User.find_from_cache(params[:user_id])
    puts "this is test" 
    render :json => [].to_json if user.nil? and return
    render :json => [].to_json if user.security_key != params[:security_key] and return
    render :json => UserVisit.select("id, controller_name, action_name, rest").where("app_id = ? and user_id = ?", params[:app_id].to_i, user.id).to_json and return
  end

end