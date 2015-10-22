class Lesson < ActiveRecord::Base
  has_many :lesson_marks
  has_many :users, through: :lesson_marks

  validates :group_id, :date, presence: true
  LESSON_GROUP = { I18n.t(:admin) => 0, I18n.t(:middle_group) =>  1,  I18n.t(:senior_group) => 2 }
end
