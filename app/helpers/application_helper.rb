module ApplicationHelper

  def status_code
    {
      0 => 'ok',
      1 => 'have errors'
    }
      .merge!(category_status_code)
      .merge!(case_status_code)
  end

  def category_status_code
    {
      50001 => 'category name can not be blank',
      50002 => 'category name already exists',
      50003 => 'category parent_id is invalid',
      50004 => 'category not exists'
    }
  end

  def case_status_code
    {
      50101 => 'case title can not be blank',
      50102 => 'case content can not be blank',
      50103 => 'case category_id can not be blank',
      50104 => 'case title already exists',
      50105 => 'category not exists',
      50106 => 'case not exists'
    }
  end

  def gen_payload (code = 0)
    { code: code, msg: status_code[code] }
  end

  def r_json (payload = {}, http_status = :ok)
    if payload.blank?
      render(json: gen_payload, status: http_status)
    else
      render(json: payload, status: http_status)
    end
  end

end
