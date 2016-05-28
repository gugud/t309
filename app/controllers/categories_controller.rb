class CategoriesController < ApplicationController
  before_action :set_page_params, only: [:cases]


  def index
    categories = Category.all
    data = categories.as_json.map do |category|
      category.merge!(total: Category.find(category['id']).cases.count)
    end
    r_json(gen_payload.merge!(data: data))
  end


  def create
    new_params = category_params

    # name不能为空
    r_json(gen_payload(50001)) && return if new_params[:name].blank?

    # 检查name是否冲突
    r_json(gen_payload(50002)) && return if Category.find_by(name: new_params[:name])

    # 检查parent_id是否合法
    unless new_params[:parent_id] == 0
      r_json(gen_payload(50003)) && return unless Category.find_by(id: new_params[:parent_id])
    end

    category = Category.new(new_params)
    if category.save
      r_json(gen_payload.merge!(data: category))
    else
      r_json({code: -1, msg: category.errors})
    end
  end


  def update
    update_params = category_params
    update_params.delete :parent_id

    # name不能为空
    r_json(gen_payload(50001)) && return if update_params[:name].blank?

    # 检查id是否合法
    category = Category.find_by(id: params[:id])
    r_json(gen_payload(50004)) && return if category.blank?

    # 检查name是否冲突
    if old = Category.find_by(name: update_params[:name])
      r_json(gen_payload(50002)) && return unless old.id == category.id
    end

    if category.update(update_params)
      r_json(gen_payload.merge!(data: category))
    else
      r_json({code: -1, msg: category.errors})
    end
  end


  def destroy
    category = Category.find_by(id: params[:id])
    r_json(gen_payload(50004)) && return if category.blank?

    if category.destroy
      r_json
    else
      r_json({code: -1, msg: category.errors})
    end
  end


  def cases
    cases = Case.where(category_id: params[:id]).page(@page).per(@limit).order(id: :desc)
    r_json(gen_payload.merge!(data: cases))
  end


  private


  def category_params
    name = params[:name]

    parent_id = params[:parent_id].to_i
    parent_id = 0 if parent_id < 0

    priority = params[:priority].to_i
    priority = 0 if priority < 0

    status = params[:status]
    if status == 'false'
      status = false
    else
      status = true
    end

    { name: name, parent_id: parent_id, priority: priority, status: status }
  end

end
