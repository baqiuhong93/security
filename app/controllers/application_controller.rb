class ApplicationController < ActionController::Base
  protect_from_forgery

  rescue_from CanCan::AccessDenied do |exception|
    render :file => "#{Rails.root}/public/403.html", :status => 403, :layout => false
  end

  def login_required
    if !current_user
      respond_to do |format|
        format.html  {
          session[LOGIN_SUC_CODE] = request.original_url if session[LOGIN_SUC_CODE].nil? && !request.xhr?
          redirect_to '/auth/joshid'
        }
        format.json {
          render :json => { 'error' => 'Access Denied' }.to_json
        }
      end
    end
  end

  def current_user
    return nil unless session[:user_id]
    @current_user ||= User.find_from_cache(session[:user_id]['uid'])
  end

end
