class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  has_many :lesson_marks
  has_many :lessons, through: :lesson_marks
  validates :group_id, :name, presence: true

  def mark_for_lesson(lesson)
    lesson_marks.where(lesson: lesson).first.try(:mark_for_lesson)
  end

  def mark_for_homework(lesson)
    lesson_marks.where(lesson: lesson).first.try(:mark_for_homework)
  end

end
