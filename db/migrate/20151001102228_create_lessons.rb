class CreateLessons < ActiveRecord::Migration
  def change
    create_table :lessons do |t|
      t.datetime :date
      t.string :hometask
      t.integer :group_id
      
      t.timestamps null: false
    end
  end
end
