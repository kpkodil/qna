class Subscribe < ApplicationRecord
  belongs_to :user
  belongs_to :question
  
  validates_presence_of :user
  validates_presence_of :question
  validates :user, uniqueness: { scope: :question }
end
