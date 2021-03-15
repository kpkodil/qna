class Answer < ApplicationRecord
  belongs_to :user
  belongs_to :question
  
  validates :body, presence: true

  validate :best_answers_count

  def make_the_best
    answers = question.answers
    answers.each do | ans |
      ans.update best: false
    end
    update best: true
  end

  def best_answers_count
    if question.present? && question.answers.where(best: true).count >= 1 && best == true
      errors.add(:best, "It must be only one best answer for any question.")
    end
  end

end
