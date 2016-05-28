require 'test_helper'

class CasesTest < ActionDispatch::IntegrationTest

  setup do
    @category = categories(:one)
  end


  test 'create a new case' do
    post '/cases', { title: '第一个案例', content: '案例内容', category_id: @category.id, priority: 0, status: true }
    assert_response :success
    res = JSON.parse response.body
    assert_equal 0, res['code']
  end


  test 'create a new case with blank title' do
    post '/cases', { title: '', content: '案例内容', category_id: @category.id, priority: 0, status: true }
    assert_response :success
    res = JSON.parse response.body
    assert_equal 50101, res['code']
  end


  test 'create a new case with blank content' do
    post '/cases', { title: '第一个案例', content: '', category_id: @category.id, priority: 0, status: true }
    assert_response :success
    res = JSON.parse response.body
    assert_equal 50102, res['code']
  end


  test 'create a new case with no category_id' do
    post '/cases', { title: '第一个案例', content: '案例内容', category_id: 0, priority: 0, status: true }
    assert_response :success
    res = JSON.parse response.body
    assert_equal 50103, res['code']
  end


  test 'create a new case with exists title' do
    one = create_a_case

    post '/cases', { title: one['data']['title'], content: '案例内容', category_id: @category.id, priority: 0, status: true }
    assert_response :success
    res = JSON.parse response.body
    assert_equal 50104, res['code']
  end


  test 'create a new case with invalid category_id' do
    post '/cases', { title: '第一个案例', content: '案例内容', category_id: @category.id + 123, priority: 0, status: true }
    assert_response :success
    res = JSON.parse response.body
    assert_equal 50105, res['code']
  end


  test 'get a case' do
    one = create_a_case

    get "/cases/#{one['data']['id']}"
    assert_response :success
    res = JSON.parse response.body
    assert_equal 0, res['code']
    assert_equal one['data']['id'], res['data']['id']
  end


  test 'update a case' do
    one = create_a_case

    put "/cases/#{one['data']['id']}", { title: '第一个案例修正', content: '案例内容修正', priority: 0, status: true }
    assert_response :success
    res = JSON.parse response.body
    assert_equal 0, res['code']
    assert_equal one['data']['id'], res['data']['id']
    assert_equal '第一个案例修正', res['data']['title']
    assert_equal '案例内容修正', res['data']['content']
  end


  test 'update a case with blank title' do
    one = create_a_case

    put "/cases/#{one['data']['id']}", { title: '', content: '案例内容修正', priority: 0, status: true }
    assert_response :success
    res = JSON.parse response.body
    assert_equal 50101, res['code']
  end


  test 'update a case with blank content' do
    one = create_a_case

    put "/cases/#{one['data']['id']}", { title: '第一个案例修正', content: '', priority: 0, status: true }
    assert_response :success
    res = JSON.parse response.body
    assert_equal 50102, res['code']
  end


  test 'update a case with invalid id' do
    one = create_a_case

    put "/cases/#{one['data']['id'] + 1}", { title: '第一个案例修正', content: '案例内容修正', priority: 0, status: true }
    assert_response :success
    res = JSON.parse response.body
    assert_equal 50106, res['code']
  end


  test 'update a case with exists title' do
    one = create_a_case
    two = create_a_case(@category.id, '第二个案例')

    put "/cases/#{one['data']['id']}", { title: two['data']['title'], content: '案例内容修正', priority: 0, status: true }
    assert_response :success
    res = JSON.parse response.body
    assert_equal 50104, res['code']
  end


  test 'delete a case' do
    one = create_a_case

    delete "/cases/#{one['data']['id']}"
    assert_response :success
    res = JSON.parse response.body
    assert_equal 0, res['code']
  end


  private


  # 创建一个案例
  def create_a_case (category_id = @category.id, title = '第一个案例')
    post '/cases', { title: title, content: '案例内容', category_id: category_id, priority: 0, status: true }
    assert_response :success
    JSON.parse response.body
  end

end
