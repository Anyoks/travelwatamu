# == Schema Information
#
# Table name: roles
#
#  id   :integer          not null, primary key
#  name :string
#

class Role < ApplicationRecord
	has_many :users
end
