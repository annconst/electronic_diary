class LessonsController < ApplicationController

  def index
    @user = current_user
    @week = week_params[:week].to_i || 0
    start_day = (Time.now + @week.weeks).at_beginning_of_week
    @week_days = (0..4).map { |day_num| (start_day + day_num.days).to_date }
    @lessons_by_day = Lesson.where(date: start_day..start_day.end_of_week)
                                         .group_by{|lesson| lesson.date.to_date}
  end

  def show
    @user = current_user
    @lesson = Lesson.where(id: params[:id]).first
    return redirect_to(lessons_path, flash[:error] = t(:error_show)) unless @lesson
    @users = User.where(group_id: @lesson.group_id).includes(:lesson_marks)
  end

  def new
    @lesson = Lesson.new
    @lesson.documents.build
  end

  def create
    @lesson = Lesson.new(lesson_params)
    if @lesson.save
      create_document(@lesson)
    else
      flash[:error] = t(:error_create)
    end
    redirect_to lessons_path
  end

  def update
    @lesson = Lesson.where(id: params[:id]).first
    flash[:error] = t(:error_update) unless @lesson.update_attributes(lesson_params)
    Lesson.transaction do
      lessons_marks_params[:users].each do |lesson_mark_params|
        lesson_user = @lesson.lesson_marks.find_by_user_id(lesson_mark_params[:user_id])
        if lesson_user.present?
          lesson_user.update_attributes(lesson_mark_params)
        else
          @lesson.lesson_marks.create(lesson_mark_params)
        end
      end
    end
    if @lesson.update_attributes(lesson_params)
      create_document(@lesson)
    else
      flash[:error] = t(:error_update)
    end
    return redirect_to :back
  end

  def create_document(lesson)
    docs = params[:documents]
    if docs.present?
      if docs.is_a? Array
        docs.each { |doc| lesson.documents.create file: doc}
      else
        lesson.documents.create file: docs
      end
    end
  end

  def destroy_all_documents
    @lesson = Lesson.find(params[:id])
    @lesson.documents.each do |del_doc|
      del_doc.destroy
    end
    @lesson.save
    redirect_to :back

  end

  private

  def lesson_params
    params.require(:lesson).permit(:hometask, :date, :group_id, documents_attributes: [:id, :name, :file] )
  end

  def lessons_marks_params
    params.permit(users: [:user_id, :mark_for_lesson, :mark_for_homework])
  end

  def week_params
    params.permit(:week)
  end

end
