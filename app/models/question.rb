class Question < ApplicationRecord
  belongs_to :user

  has_many :answers, dependent: :destroy
  has_one :best_answer, -> { where(best: true ) }, class_name: 'Answer'
  
  validates :title, :body, presence: true
end
