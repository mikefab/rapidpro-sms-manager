require 'test_helper'

class CompletionsControllerTest < ActionController::TestCase
  setup do
    @completion = completions(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:completions)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create completion" do
    assert_difference('Completion.count') do
      post :create, completion: { flow: @completion.flow, ids: @completion.ids, phone: @completion.phone, primary: @completion.primary, run: @completion.run, step: @completion.step, steps: @completion.steps, values: @completion.values }
    end

    assert_redirected_to completion_path(assigns(:completion))
  end

  test "should show completion" do
    get :show, id: @completion
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @completion
    assert_response :success
  end

  test "should update completion" do
    patch :update, id: @completion, completion: { flow: @completion.flow, ids: @completion.ids, phone: @completion.phone, primary: @completion.primary, run: @completion.run, step: @completion.step, steps: @completion.steps, values: @completion.values }
    assert_redirected_to completion_path(assigns(:completion))
  end

  test "should destroy completion" do
    assert_difference('Completion.count', -1) do
      delete :destroy, id: @completion
    end

    assert_redirected_to completions_path
  end
end
