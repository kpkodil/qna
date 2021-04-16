class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  
  has_many :questions, dependent: :destroy         
  has_many :answers, dependent: :destroy

  has_many :reward_ownings, dependent: :destroy
  has_many :rewards, through: :reward_ownings

  has_many :votes, dependent: :destroy

  has_many :comments, dependent: :destroy

  has_many :subscribes, dependent: :destroy

  def resource_author?(resource)
    resource.user_id == id    
  end
end
