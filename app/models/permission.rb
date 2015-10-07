class Permission < ActiveRecord::Base
	
  attr_accessible :app_id, :menu_id, :name, :order_num, :rest
  has_and_belongs_to_many :roles
end
