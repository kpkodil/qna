class Answer < ApplicationRecord

  include Votable
  include Commentable
  
  belongs_to :user
  belongs_to :question

  has_many :links, dependent: :destroy, as: :linkable

  has_many_attached :files
  
  accepts_nested_attributes_for :links, reject_if: :all_blank

  validates :body, presence: true

  validate :best_answers_count

  def make_the_best
    Answer.transaction do
      unless best?
        question.answers.update_all(best: false)
        update!(best: true)
        question.reward.reward_the_user(user) if question.reward.present?
      end
    end
  end

  def best_answers_count
    if question.present? && question.answers.where(best: true).count >= 1 && best? && question.best_answer != self
      errors.add(:best, "It must be only one best answer for any question.")
    end
  end
end
