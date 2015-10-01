class LessonMark < ActiveRecord::Base
  belongs_to :user
  belongs_to :lesson
end
