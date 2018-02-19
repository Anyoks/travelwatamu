require 'test_helper'

class TuktuksControllerTest < ActionDispatch::IntegrationTest
  setup do
    @tuktuk = tuktuks(:one)
  end

  test "should get index" do
    get tuktuks_url
    assert_response :success
  end

  test "should get new" do
    get new_tuktuk_url
    assert_response :success
  end

  test "should create tuktuk" do
    assert_difference('Tuktuk.count') do
      post tuktuks_url, params: { tuktuk: { first_name: @tuktuk.first_name, last_name: @tuktuk.last_name, number_plate: @tuktuk.number_plate, phone_number: @tuktuk.phone_number, stage: @tuktuk.stage, status: @tuktuk.status } }
    end

    assert_redirected_to tuktuk_url(Tuktuk.last)
  end

  test "should show tuktuk" do
    get tuktuk_url(@tuktuk)
    assert_response :success
  end

  test "should get edit" do
    get edit_tuktuk_url(@tuktuk)
    assert_response :success
  end

  test "should update tuktuk" do
    patch tuktuk_url(@tuktuk), params: { tuktuk: { first_name: @tuktuk.first_name, last_name: @tuktuk.last_name, number_plate: @tuktuk.number_plate, phone_number: @tuktuk.phone_number, stage: @tuktuk.stage, status: @tuktuk.status } }
    assert_redirected_to tuktuk_url(@tuktuk)
  end

  test "should destroy tuktuk" do
    assert_difference('Tuktuk.count', -1) do
      delete tuktuk_url(@tuktuk)
    end

    assert_redirected_to tuktuks_url
  end
end
