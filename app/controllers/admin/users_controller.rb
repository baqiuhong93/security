# encoding: utf-8

class Admin::UsersController < ApplicationController
  before_filter :login_required
  load_and_authorize_resource
  before_filter :init_breadcrumb_and_module_name
  layout "admin"
  
  # GET /users
  # GET /users.json
  def index
    @search = User.search(params[:search])
    @users = @search.paginate(:page => params[:page], :per_page => 10).order('id DESC')

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @users }
    end
  end

  # GET /users/1
  # GET /users/1.json
  def show
    @user = User.find(params[:id])
    
    drop_breadcrumb(@user.name, admin_user_path(@user))
    
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @user }
    end
  end

  # GET /users/new
  # GET /users/new.json
  def new
    @user = User.new
    
    drop_breadcrumb('新增')
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @user }
    end
  end

  # GET /users/1/edit
  def edit
    @user = User.find(params[:id])
    
    drop_breadcrumb(@user.name, admin_user_path(@user))
    drop_breadcrumb('修改')
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new params.require(:user).permit(:name, :code, :keywords, :description, :origin_price, :sale_price, :user_type, :effect_type, :effect_str, :onlined_at, :expired_at)

    respond_to do |format|
      if @user.save
        format.html { redirect_to admin_user_path(@user), notice: '用户新建成功.' }
        format.json { render json: @user, status: :created, location: @user }
      else
        format.html { render action: "new" }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /users/1
  # PUT /users/1.json
  def update
    @user = User.find(params[:id])

    respond_to do |format|
      if @user.update_attributes(params.require(:user).permit(:name, :code, :keywords, :description, :origin_price, :sale_price, :user_type, :effect_type, :effect_str, :onlined_at, :expired_at, :tag_list))
        format.html { redirect_to admin_user_url(@user), notice: '用户修改成功.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user = User.find(params[:id])
    @user.destroy

    respond_to do |format|
      format.html { redirect_to admin_users_path }
      format.json { head :no_content }
    end
  end
  
  def edit_role
     @user = User.find(params[:id])
  end
  
  def update_role
    @user = User.find(params[:id])
    @user.transaction do
      @user.user_roles.destroy_all
      select_roles = params[:user_roles]
      select_roles.each do |role_id|
        @user.user_roles.create(:role_id => role_id)
      end unless select_roles.nil?
      respond_to do |format|
        if @user.save!
         @user.user_visits.destroy_all
         @user.roles.joins(:permissions).select('permissions.controller_name,permissions.action_name,permissions.rest,roles.app_id').each do |record|
            UserVisit.create :controller_name => record.controller_name, :action_name => record.action_name, :rest => record.rest, :app_id => record.app_id, :user_id => @user.id
          end

          # delete user visits cache
          PUBLIC_CACHE.delete("1_user_visits_" + @user.id.to_s)
          PUBLIC_CACHE.delete("2_user_visits_" + @user.id.to_s)
          PUBLIC_CACHE.delete("3_user_visits_" + @user.id.to_s)

          format.html { redirect_to admin_user_path(@user), notice: '权限修改成功.' }
          format.json { head :no_content }
        else
          format.html { render action: "edit_role" }
          format.json { render json: @user.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  def reset_pwd
    pwd = SecureRandom.uuid[0..7]
    @user = User.find_by_id(params[:id])
    @user.password = pwd
    @user.password_confirmation = pwd
    if @user.save
      render :json => {"status" => "success", "password" => pwd}
    else
      render :json => {"status" => "error"}
    end
  end
  
  private
  
  def init_breadcrumb_and_module_name
    drop_breadcrumb("用户", admin_users_path)
    @_module_name = 'user'
    @_module_delete = false
    @_module_new = false
  end
end
