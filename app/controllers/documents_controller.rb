class DocumentsController < ApplicationController

  def destroy
    Document.find(params[:id]).destroy
    redirect_to :back
  end

end
