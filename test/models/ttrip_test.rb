# == Schema Information
#
# Table name: ttrips
#
#  id               :uuid             not null, primary key
#  status           :string
#  ttrip_request_id :uuid
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#

require 'test_helper'

class TtripTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
