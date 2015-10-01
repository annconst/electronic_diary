class CreateLessonMarks < ActiveRecord::Migration
  def change
    create_table :lesson_marks do |t|
      t.references :user
      t.references :lesson
      t.integer :mark_for_lesson
      t.integer :mark_for_homework

      t.timestamps null: false
    end
  end
end
