module VotesHelper
  def vote_hidden(votable)
    'hidden' if votable.votes.where(user: current_user).present?
  end

  def delete_vote_hidden(votable)
    'hidden' unless votable.votes.where(user: current_user).present?
  end
end