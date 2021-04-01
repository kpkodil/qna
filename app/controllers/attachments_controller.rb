class AttachmentsController < ApplicationController

  before_action :authenticate_user!

  before_action :file, only: %i[destroy]

  def destroy
    authorize! :destroy, @file
    @file.purge if current_user.resource_author?(@file.record)
  end

  private

  def file
    @file ||= ActiveStorage::Attachment.find(params[:file]) 
  end
end
