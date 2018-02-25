# == Schema Information
#
# Table name: sms_btrip_requests
#
#  id               :uuid             not null, primary key
#  phone_number     :string
#  sent_sms         :string
#  received_sms     :string
#  status           :string
#  btrip_request_id :uuid
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#

require 'test_helper'

class SmsBtripRequestTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
