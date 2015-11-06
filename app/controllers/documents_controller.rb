class DocumentsController < ApplicationController

  def destroy
    @document = Document.where(id: params[:id]).first
    if @document.present?
      @document.destroy
    else
      flash[:error] = t(:error_delete)
    end
    redirect_to :back
  end

end
