class User < ActiveRecord::Base

	devise :database_authenticatable, :registerable,
           :recoverable, :timeoutable, :trackable, :validatable, :rememberable, :lockable, :authentication_keys => [:login]

	after_save :delete_cache

	attr_accessible :email, :password, :password_confirmation, :name, :last_name, :salt

	has_many :user_roles
	has_many :roles, :through => :user_roles
	has_many :user_visits


	def security_key
		Digest::MD5.hexdigest(self.id.to_s + "_" + self.salt + "_" + DateTime.now.strftime("%Y%m%d"))
	end

	private

	def self.find_from_cache(id)
		APP_CACHE.fetch("users_#{id}", 0) do
			User.where("id = ?", id).first
		end
	end

	def delete_cache
		APP_CACHE.delete("users_#{self.id}")
	end
end
