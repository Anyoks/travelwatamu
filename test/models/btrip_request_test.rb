# == Schema Information
#
# Table name: btrip_requests
#
#  id           :uuid             not null, primary key
#  phone_number :string
#  location     :string
#  bajaj_id     :uuid
#  status       :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  sms_id       :uuid
#

require 'test_helper'

class BtripRequestTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
