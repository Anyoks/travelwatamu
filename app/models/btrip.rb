# == Schema Information
#
# Table name: btrips
#
#  id               :uuid             not null, primary key
#  status           :string
#  btrip_request_id :uuid
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#

class Btrip < ApplicationRecord
	belongs_to :btrip_request
end
