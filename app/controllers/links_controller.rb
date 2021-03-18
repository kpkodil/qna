class LinksController < ApplicationController
  before_action :authenticate_user!

  before_action :link, only: %i[destroy]


  def destroy
    @link.destroy if current_user.resource_author?(@link.linkable)
  end

  private

  def link
    @link ||= Link.find(params[:link]) 
  end
end
