# encoding: utf-8

class Admin::RolesController < ApplicationController
  before_filter :login_required
  load_and_authorize_resource
  before_filter :init_breadcrumb_and_module_name
  layout "admin"
  
  # GET /users
  # GET /users.json
  def index
    @users = User.where(:admin => true).paginate(:page => params[:page], :per_page => 10).order('id DESC')
    
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @users }
    end
  end

  # GET /users/1
  # GET /users/1.json
  def show
    @user = User.where(params[:id])
    
    drop_breadcrumb(@user.name, admin_role_path(@user))
    
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
    
    drop_breadcrumb(@user.name, admin_role_path(@user))
    drop_breadcrumb('修改')
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.where(:name => params[:user][:name]).first
    if @user.nil?
      @user = User.new
      flash[:notice] = '用户不存在！'
      respond_to do |format|
        format.html { render action: "new" }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
      return
    end
    
    if @user.admin
      @user = User.new
      flash[:notice] = '用户已经是管理员！'
      respond_to do |format|
        format.html { render action: "new" }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
      return
    end
    
    select_roles = params[:user_roles]
    select_roles.each do |role_id|
      @user.user_roles.create(:role_id => role_id)
    end unless select_roles.nil?
    
    @user.admin = true
    
    respond_to do |format|
      if @user.save
        @user.roles.joins(:permissions).select('permissions.controller_name,permissions.action_name,permissions.rest,roles.app_id').each do |record|
          UserVisit.create :controller_name => record.controller_name, :action_name => record.action_name, :rest => record.rest, :app_id => record.app_id, :user_id => @user.id
        end
        format.html { redirect_to admin_role_path(@user), notice: '权限新建成功.' }
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
          format.html { redirect_to admin_role_url(@user), notice: '权限修改成功.' }
          format.json { head :no_content }
        else
          format.html { render action: "edit" }
          format.json { render json: @user.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user = User.find(params[:id])
    @user.transaction do
      @user.user_roles.destroy_all
      @user.update_attribute(:admin, false)
    end
    respond_to do |format|
      format.html { redirect_to admin_roles_path }
      format.json { head :no_content }
    end
  end
  
  
  def test
    
  end
  
  private
  
  def init_breadcrumb_and_module_name
    drop_breadcrumb("权限", admin_roles_path)
    @_module_name = 'role'
  end
end
