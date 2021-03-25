class Vote < ApplicationRecord
  belongs_to :user
  belongs_to :votable, polymorphic: true

  validates :vote_value, presence: true,
                         numericality: { equal: -> { -1 || 1 },
                                         only_integer: true }

  validates :user_id, uniqueness: { scope: [ :votable_id, :votable_type ] }

  validate :votable_author

  def votable_author
    if votable &&  user&.resource_author?(votable)
      errors.add(:user, "can not be an author of votable resource!")
    end
  end
end
