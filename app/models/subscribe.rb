class Subscribe < ApplicationRecord
  belongs_to :subscriber, class_name: "User", foreign_key: "user_id"
  belongs_to :question
  
  validates_presence_of :subscriber
  validates_presence_of :question
  validates :subscriber, uniqueness: { scope: :question }
end
