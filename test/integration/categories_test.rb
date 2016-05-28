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


  test 'update a category' do
    one = create_a_category

    put "/categories/#{one['data']['id']}", { name: '第一个分类修正', priority: 0, status: true }
    assert_response :success
    res = JSON.parse response.body
    assert_equal 0, res['code']
    assert_equal one['data']['id'], res['data']['id']
    assert_equal '第一个分类修正', res['data']['name']
  end


  test 'update a category with blank name' do
    one = create_a_category

    put "/categories/#{one['data']['id']}", { name: '', priority: 0, status: true }
    assert_response :success
    res = JSON.parse response.body
    assert_equal 50001, res['code']
  end


  test 'update a category with invalid id' do
    one = create_a_category

    put "/categories/#{one['data']['id'] + 1}", { name: '第一个分类修正', priority: 0, status: true }
    assert_response :success
    res = JSON.parse response.body
    assert_equal 50004, res['code']
  end


  test 'update a category with exists name' do
    one = create_a_category
    two = create_a_category('第二个分类')

    put "/categories/#{one['data']['id']}", { name: two['data']['name'], priority: 0, status: true }
    assert_response :success
    res = JSON.parse response.body
    assert_equal 50002, res['code']
  end


  test 'delete a category' do
    one = create_a_category

    delete "/categories/#{one['data']['id']}"
    assert_response :success
    res = JSON.parse response.body
    assert_equal 0, res['code']
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
  def create_a_category (name = '第一个分类')
    post '/categories', { name: name, parent_id: 0, priority: 0, status: true }
    assert_response :success
    JSON.parse response.body
  end

end
