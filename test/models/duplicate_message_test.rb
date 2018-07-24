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

require 'test_helper'

class DuplicateMessageTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
