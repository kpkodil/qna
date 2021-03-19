class Reward < ApplicationRecord

  belongs_to :question

  has_one :reward_owning, dependent: :destroy
  has_one :user, through: :reward_owning

  validates :title, presence: true
  validates :image_url, presence: true

  validates :image_url, format: { with: URI::regexp }
end
