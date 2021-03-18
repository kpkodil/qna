class Link < ApplicationRecord
  belongs_to :linkable, polymorphic: true

  validates :name,:url, presence: true

  validates :url, format: { with: URI::regexp }

  def a_gist?
    url.start_with?("https://gist.github.com/kpkodil/")
  end
end
