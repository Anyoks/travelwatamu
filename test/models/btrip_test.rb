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

require 'test_helper'

class BtripTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
