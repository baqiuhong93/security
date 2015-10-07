class HomeController < ApplicationController
  before_filter :login_required#, :except => :index

  def index
  	redirect_to admin_root_path
  end
end
