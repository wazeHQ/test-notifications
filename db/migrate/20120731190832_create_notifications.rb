class CreateNotifications < ActiveRecord::Migration
  def change
    create_table :notifications do |t|
      t.integer :created_by
      t.string :title
      t.text :description
      t.integer :votes_up
      t.boolean :is_active
      t.float :lon
      t.float :lat

      t.timestamps
    end
  end
end
