class CreateCategories < ActiveRecord::Migration
  def change
    create_table :categories do |t|
      t.string :name, default: ''
      t.integer :parent_id, default: 0
      t.integer :priority, default: 0
      t.boolean :status, default: true

      t.timestamps null: false
    end
  end
end
