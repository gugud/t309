class CreateCases < ActiveRecord::Migration
  def change
    create_table :cases do |t|
      t.integer :category_id, default: 0
      t.string :title, default: ''
      t.text :content
      t.integer :priority, default: 0
      t.boolean :status, default: true

      t.timestamps null: false
    end
  end
end
