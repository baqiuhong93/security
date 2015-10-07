class UsersApiController < Sinatra::Base

  get "/users/:app_id/:user_id/permissions/:security_key" do
    user = User.find_from_cache(params[:user_id])
    return [].to_json if user.nil?
    return [].to_json if user.security_key != params[:security_key]
    UserVisit.select("id, controller_name, action_name, rest").where("app_id = ? and user_id = ?", params[:app_id].to_i, user.id).to_json
  end

end