# == Schema Information
#
# Table name: sms_ttrip_requests
#
#  id               :uuid             not null, primary key
#  phone_number     :string
#  sent_sms         :string
#  received_sms     :string
#  status           :string
#  ttrip_request_id :uuid
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#

require 'test_helper'

class SmsTtripRequestTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
