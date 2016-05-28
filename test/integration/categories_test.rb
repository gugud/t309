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


  test 'get cases list' do
    one = create_a_category

    # 在该分类下创建100个案例
    100.times do |num|
      Case.create!(title: "标题#{num}", content: "内容#{num}", category_id: one['data']['id'])
    end

    # 取第3页，每页15条
    get "/categories/#{one['data']['id']}/cases", { page: 3, limit: 15 }
    assert_response :success
    res = JSON.parse response.body
    assert_equal 0, res['code']
    assert_equal 15, res['data'].size
  end


  private


  # 创建一个分类
  def create_a_category
    post '/categories', { name: '第一个分类', parent_id: 0, priority: 0, status: true }
    assert_response :success
    JSON.parse response.body
  end

end
