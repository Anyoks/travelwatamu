# == Schema Information
#
# Table name: bajajs
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

require 'test_helper'

class BajajTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
