class Reward < ApplicationRecord

  belongs_to :question

  has_one :reward_owning, dependent: :destroy
  has_one :user, through: :reward_owning

  validates :title, presence: true
  validates :image_url, presence: true

  validates :image_url, format: { with: URI::regexp }

  def reward_the_user(answer_user)
    self.user = answer_user
  end
end
