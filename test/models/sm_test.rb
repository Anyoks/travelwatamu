# == Schema Information
#
# Table name: sms
#
#  id               :uuid             not null, primary key
#  message          :string
#  transport_mode   :string
#  phone_number     :string
#  current_location :string
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  duplicate        :boolean          default(FALSE)
#

require 'test_helper'

class SmTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
