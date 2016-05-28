class Category < ActiveRecord::Base
  validates :name, presence: true
  validates :name, uniqueness: { message: '分类名已存在' }, allow_blank: false

  has_many :cases
end
