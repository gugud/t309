require 'test_helper'

class CategoriesTest < ActionDispatch::IntegrationTest

  test 'get all categories' do
    get "/categories"
    assert_response :success
    res = JSON.parse response.body
    assert_equal 0, res['code']
  end


  test 'create a new category' do
    post '/categories', { name: '第一个分类', parent_id: 0, priority: 0, status: true }
    assert_response :success
    res = JSON.parse response.body
    assert_equal 0, res['code']
  end


  test 'create a new category with blank name' do
    post '/categories', { name: '', parent_id: 0, priority: 0, status: true }
    assert_response :success
    res = JSON.parse response.body
    assert_equal 50001, res['code']
  end


  test 'create a new category with exists name' do
    one = create_a_category

    post '/categories', { name: one['data']['name'], parent_id: 0, priority: 0, status: true }
    assert_response :success
    res = JSON.parse response.body
    assert_equal 50002, res['code']
  end


  test 'create a new category with invalid parent_id' do
    one = create_a_category

    post '/categories', { name: '第二个分类', parent_id: one['data']['id'] + 1, priority: 0, status: true }
    assert_response :success
    res = JSON.parse response.body
    assert_equal 50003, res['code']
  end


  private


  # 创建一个分类
  def create_a_category
    post '/categories', { name: '第一个分类', parent_id: 0, priority: 0, status: true }
    assert_response :success
    JSON.parse response.body
  end

end
