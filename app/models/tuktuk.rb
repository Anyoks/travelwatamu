# == Schema Information
#
# Table name: tuktuks
#
#  id           :uuid             not null, primary key
#  first_name   :string
#  last_name    :string
#  number_plate :string
#  phone_number :string
#  stage        :string
#  status       :boolean
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#


# status:
# true means the tuktuk is available
# false means it is not available. Maybe they are busy now.
# default is false ------>maybe I should change this.
class Tuktuk < ApplicationRecord
	has_many :ttrip_requests
	has_many :sms_ttrip_request,  through: :ttrip_requests
end
