class Answer < ApplicationRecord
  belongs_to :user
  belongs_to :question
  
  validates :body, presence: true

  validate :best_answers_count

  def make_the_best
    Answer.transaction do
      unless best?
        question.answers.update_all(best: false)
        update!(best: true)
      end
    end
  end

  def best_answers_count
    if question.present? && question.answers.where(best: true).count >= 1 && best?
      errors.add(:best, "It must be only one best answer for any question.")
    end
  end
end
