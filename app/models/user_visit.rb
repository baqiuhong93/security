class UserVisit < ActiveRecord::Base
	attr_accessible :action_name, :app_id, :controller_name, :user_id, :rest
end
