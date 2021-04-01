class CommentsController < ApplicationController

  before_action :authenticate_user!, only: %i[ create ]
  before_action :commentable,        only: %i[ create ]

  authorize_resource
  
  after_action :publish_comment, only: %i[create]

  def create
    respond_to do |format|
      @comment = current_user.comments.build(comment_params)
      @comment.commentable = @commentable    
      
      if @comment.save
        format.json { render json: { comment: @comment, commentable: @comment.commentable } }
      else
        format.json do 
          render json: {errors: @comment.errors.full_messages },
                 status: :unprocessable_entity 
        end
      end  
    end
  end

  private

  def commentable
    @commentable ||= Question.find(params[:question_id]) if params[:question_id]
    @commentable ||= Answer.find(params[:answer_id]) if params[:answer_id]
  end

  def comment_params
    params.require(:comment).permit(:body)
  end

  def question_id
    if params[:question_id]
      @commentable.id 
    elsif params[:answer_id]
      @commentable.question_id
    end
  end

  def publish_comment
    return if @comment.errors.any?
    ActionCable.server.broadcast( 
      "question_#{question_id}/comments", 
      { comment: @comment
      } 
    )
  end
end