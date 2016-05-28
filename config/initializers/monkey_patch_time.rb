class ActiveSupport::TimeWithZone
  def as_json (options = {})
    self.to_i
  end
end
