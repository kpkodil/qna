class Subscribe < ApplicationRecord
  belongs_to :subscriber, class_name: "User", foreign_key: "user_id"
  belongs_to :question
  
  validates_presence_of :user
  validates_presence_of :question
  validates :user, uniqueness: { scope: :question }
end
