class LessonsController < ApplicationController

  def index
    @week = week_params[:week].to_i || 0
    start_day = (Time.now + @week.weeks).at_beginning_of_week
    @week_days = (0..4).map { |day_num| (start_day + day_num.days).to_date }
    @lessons_by_day = Lesson.where(date: start_day..start_day.end_of_week)
                                         .group_by{|lesson| lesson.date.to_date}
  end

  def show
    @lesson = Lesson.where(id: params[:id]).first
    return redirect_to(lessons_path, flash[:error] = t(:error_show)) unless @lesson
    @users = User.where(group_id: @lesson.group_id).includes(:lesson_marks)
  end

  def new
    @lesson = Lesson.new
  end

  def create
    @lesson = Lesson.new(lesson_params)
    flash[:error] = t(:error_create) unless @lesson.save
    redirect_to lessons_path
  end

  def update
    @lesson = Lesson.where(id: params[:id]).first
    flash[:error] = t(:error_update) unless @lesson.update_attributes(lesson_params)
    Lesson.transaction do
      lessons_marks_params[:users].each do |lesson_mark_params|
        lesson_user = @lesson.lesson_marks.where(lesson_mark_params[:user_id]).first
        if lesson_user.present?
          lesson_user.update_attributes(lesson_mark_params)
        else
          @lesson.lesson_marks.create(lesson_mark_params)
        end
      end
    end
    return redirect_to lessons_path
  end

  private

  def lesson_params
    params.require(:lesson).permit(:hometask, :date, :group_id)
  end

  def lessons_marks_params
    params.permit(users: [:user_id, :mark_for_lesson, :mark_for_homework])
  end

  def week_params
    params.permit(:week)
  end

end
