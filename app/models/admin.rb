class Admin < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  belongs_to :role
  before_validation :set_default_role
  devise :database_authenticatable, :registerable,
		 :recoverable, :rememberable, :trackable, :validatable
  before_create :set_default_role

   


   def is_admin?
		if self.role.nil?
			false
		elsif self.role.name == "admin"
			true
		else
			false
		end
	end

	def set_default_role
		self.role ||= Role.find_by_name('moderator') 
	end

	def make_admin
		self.update_attributes :role_id => 2
	end

	def show_admins
		User.where(:role_id => 2 )
	end

	def make_moderator
		self.update_attributes :role_id => 1
	end

   protected
   def set_default_role
	   self.role ||= Role.find_by_name('moderator') 
	
   end
end
