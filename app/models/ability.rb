require 'user_visit'

class Ability
  include CanCan::Ability

  def initialize(user)
    
    #can 'read'.to_sym, 'Product'.constantize, 'product_type => 2'.to_sym
    #can 'read'.to_sym, 'Role'.constantize
    #can :new, Role
    #can :edit, Role
    #can :create, Role
    #can :update, Role
    #can :destroy, Role
    #can :show, Role
    #can :index, Product
    #can :read, Role
    #puts user.admin
    if user.email == SYSTEM_ADMIN_USER_NAME
      can :manage, :all
    else
        user_visits = PUBLIC_CACHE.fetch("#{DEFINE_APP_ID}_user_visits_" + user.id.to_s) do
            UserVisit.where("app_id = ? and user_id = ?", DEFINE_APP_ID, user.id)
        end

        user_visits.each do |user_visit|
            can user_visit.action_name.to_sym, user_visit.controller_name.constantize if user_visit.rest
            can user_visit.action_name.to_sym, user_visit.controller_name.to_sym unless user_visit.rest
        end unless user_visits.nil?
        can :index, :home if !user_visits.nil? && user_visits.length > 0
    end
    
    #if !user.nil? && user.admin
      #user_permissions = user.roles.joins(:permissions).select('permissions.controller_name,permissions.action_name').where("roles.app_id=#{APP_ID}")
    #  user_permissions = user.user_visits.where("app_id = #{APP_ID}")
    #  user_permissions.each do |permission|
    #    can permission.action_name.to_sym, permission.controller_name.constantize
    #  end
    #end
    
    # Define abilities for the passed in user here. For example:
    #
    #   user ||= User.new # guest user (not logged in)
    #   if user.admin?
    #     can :manage, :all
    #   else
    #     can :read, :all
    #   end
    #
    # The first argument to `can` is the action you are giving the user permission to do.
    # If you pass :manage it will apply to every action. Other common actions here are
    # :read, :create, :update and :destroy.
    #
    # The second argument is the resource the user can perform the action on. If you pass
    # :all it will apply to every resource. Otherwise pass a Ruby class of the resource.
    #
    # The third argument is an optional hash of conditions to further filter the objects.
    # For example, here the user can only update published articles.
    #
    #   can :update, Article, :published => true
    #
    # See the wiki for details: https://github.com/ryanb/cancan/wiki/Defining-Abilities
  end
end
