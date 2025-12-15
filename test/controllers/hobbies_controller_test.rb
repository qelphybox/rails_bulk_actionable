require "test_helper"

class HobbiesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @hobby = hobbies(:one)
  end

  test "should get index" do
    get hobbies_url
    assert_response :success
  end

  test "should get new" do
    get new_hobby_url
    assert_response :success
  end

  test "should create hobby" do
    assert_difference("Hobby.count") do
      post hobbies_url, params: { hobby: { name: @hobby.name } }
    end

    assert_redirected_to hobby_url(Hobby.last)
  end

  test "should show hobby" do
    get hobby_url(@hobby)
    assert_response :success
  end

  test "should get edit" do
    get edit_hobby_url(@hobby)
    assert_response :success
  end

  test "should update hobby" do
    patch hobby_url(@hobby), params: { hobby: { name: @hobby.name } }
    assert_redirected_to hobby_url(@hobby)
  end

  test "should destroy hobby" do
    assert_difference("Hobby.count", -1) do
      delete hobby_url(@hobby)
    end

    assert_redirected_to hobbies_url
  end
end
