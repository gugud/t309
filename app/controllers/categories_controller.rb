class CategoriesController < ApplicationController

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
  end


  def destroy
  end


  def cases
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
