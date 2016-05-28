class Case < ActiveRecord::Base
  validates :category_id, :title, :content, presence: true
  validates :title, uniqueness: { message: '标题已存在' }, allow_blank: false

  belongs_to :category
end
