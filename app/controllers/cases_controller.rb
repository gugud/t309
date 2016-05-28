class CasesController < ApplicationController

  def show
    this_case = Case.find(params[:id])
    r_json(gen_payload(50106)) && return if this_case.blank?

    r_json(gen_payload.merge!(data: this_case))
  end


  def create
    new_params = case_params

    # title不能为空
    r_json(gen_payload(50101)) && return if new_params[:title].blank?

    # content不能为空
    r_json(gen_payload(50102)) && return if new_params[:content].blank?

    # category_id不能为空
    r_json(gen_payload(50103)) && return if new_params[:category_id] == 0

    # 检查title是否冲突
    r_json(gen_payload(50104)) && return if Case.find_by(title: new_params[:title])

    # 检查category_id是否合法
    unless new_params[:category_id] == 0
      r_json(gen_payload(50105)) && return unless Category.find_by(id: new_params[:category_id])
    end

    this_case = Case.new(new_params)
    if this_case.save
      r_json(gen_payload.merge!(data: this_case))
    else
      r_json({code: -1, msg: this_case.errors})
    end
  end


  def update
    update_params = case_params
    update_params.delete :category_id

    # title不能为空
    r_json(gen_payload(50101)) && return if update_params[:title].blank?

    # content不能为空
    r_json(gen_payload(50102)) && return if update_params[:content].blank?

    # 检查id是否合法
    this_case = Case.find_by(id: params[:id])
    r_json(gen_payload(50106)) && return if this_case.blank?

    # 检查title是否冲突
    if old = Case.find_by(title: update_params[:title])
      r_json(gen_payload(50104)) && return unless old.id == this_case.id
    end

    if this_case.update(update_params)
      r_json(gen_payload.merge!(data: this_case))
    else
      r_json({code: -1, msg: this_case.errors})
    end
  end


  def destroy
    this_case = Case.find_by(id: params[:id])
    r_json(gen_payload(50106)) && return if this_case.blank?

    if this_case.destroy
      r_json
    else
      r_json({code: -1, msg: this_case.errors})
    end
  end


  private


  def case_params
    title = params[:title]
    content = params[:content]

    category_id = params[:category_id].to_i
    category_id = 0 if category_id < 0

    priority = params[:priority].to_i
    priority = 0 if priority < 0

    status = params[:status]
    if status == 'false'
      status = false
    else
      status = true
    end

    { title: title, content: content, category_id: category_id, priority: priority, status: status }
  end

end
