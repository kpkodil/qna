class AnswersController < ApplicationController
  
  include Voted

  before_action :authenticate_user!, only: %i[create update destroy]
  before_action :question, only: %i[create destroy]
  before_action :answer, only: %i[update destroy make_the_best delete_attached_file]

  authorize_resource
  
  after_action :publish_answer, only: %i[create]

  def create
    @answer = current_user.answers.build(answer_params)
    @answer.question = @question
    
    respond_to do |format|
      if @answer.save
        set_files(@answer)
        format.json { render json: { answer: @answer, links: @answer.links, files: @files } }
      else
        format.json do 
          render json: @answer.errors.full_messages,
                 status: :unprocessable_entity 
        end
      end
    end
  end

  def update
    @answer.update(answer_params)
  end

  def destroy
    @answer.destroy
  end

  def make_the_best
    @prev_best_answer = @answer.question.best_answer
    @answer.make_the_best
  end

  private

  def answer
    @answer ||= params[:id] ? Answer.with_attached_files.find(params[:id]) : Answer.new
  end 

  helper_method :answer

  def question
    @question ||= params[:question_id] ? Question.find(params[:question_id]) : answer.question
  end

  helper_method :question

  def answer_params
    params.require(:answer).permit(:body, files: [], links_attributes: [:name, :url, :_destroy] )
  end

  def set_files(answer)
    @files = []
    @answer.files.map do |f|
      file=Hash.new
      file[:name] = f.filename.to_s
      file[:url] = url_for(f)
      file[:id] = f.id
      @files << file
    end
  end

  def set_links
    @answer.links.map do |l|
      { name: l.name,
        url: l.url,
        id: l.id 
      }
    end
  end

  def publish_answer
    set_links
    return if @answer.errors.any?
    ActionCable.server.broadcast( 
      "question_#{params[:question_id]}/answers", 
      { answer: @answer,
        links: @answer.links,
        files: @files
      } 
    )
  end
end
