module Voted
  extend ActiveSupport::Concern

  included do
    before_action :authenticate_user!, only: %i[ vote_for vote_against delete_vote ]
    before_action :votable,            only: %i[ vote_for vote_against delete_vote ]
    authorize_resource
  end

  def vote_for
    create_vote(1)
  end

  def vote_against
    create_vote(-1)
  end

  def delete_vote
    respond_to do |format|
      @votable.votes.find_by(user: current_user)&.destroy
      format.json { render json:  { rating: @votable.rating } }
    end
  end

  private

  def model_klass
    controller_name.classify.constantize
  end

  def votable
    @votable ||= model_klass.find(params[:id])
  end

  def create_vote(vote_value)
    respond_to do |format|
      @vote = @votable.votes.build(user: current_user, vote_value: vote_value)
      if @vote.save
        format.json { render json:  { rating: @votable.rating } }
      else
        format.json do 
          render json: {errors: @vote.errors.full_messages },
                 status: :unprocessable_entity 
        end
      end  
    end
  end

  def authorize_vote
    authorize! @votable
  end
end