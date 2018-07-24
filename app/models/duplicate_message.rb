# == Schema Information
#
# Table name: duplicate_messages
#
#  id               :uuid             not null, primary key
#  message          :string
#  transport_mode   :string
#  phone_number     :string
#  current_location :string
#  sms_id           :uuid
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#

class DuplicateMessage < ApplicationRecord
	belongs_to :sms
end
