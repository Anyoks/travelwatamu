require 'test_helper'

class BajajsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @bajaj = bajajs(:one)
  end

  test "should get index" do
    get bajajs_url
    assert_response :success
  end

  test "should get new" do
    get new_bajaj_url
    assert_response :success
  end

  test "should create bajaj" do
    assert_difference('Bajaj.count') do
      post bajajs_url, params: { bajaj: { first_name: @bajaj.first_name, last_name: @bajaj.last_name, number_plate: @bajaj.number_plate, phone_number: @bajaj.phone_number, stage: @bajaj.stage, status: @bajaj.status } }
    end

    assert_redirected_to bajaj_url(Bajaj.last)
  end

  test "should show bajaj" do
    get bajaj_url(@bajaj)
    assert_response :success
  end

  test "should get edit" do
    get edit_bajaj_url(@bajaj)
    assert_response :success
  end

  test "should update bajaj" do
    patch bajaj_url(@bajaj), params: { bajaj: { first_name: @bajaj.first_name, last_name: @bajaj.last_name, number_plate: @bajaj.number_plate, phone_number: @bajaj.phone_number, stage: @bajaj.stage, status: @bajaj.status } }
    assert_redirected_to bajaj_url(@bajaj)
  end

  test "should destroy bajaj" do
    assert_difference('Bajaj.count', -1) do
      delete bajaj_url(@bajaj)
    end

    assert_redirected_to bajajs_url
  end
end
