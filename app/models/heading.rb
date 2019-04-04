class Heading < ApplicationRecord
  # t.integer "level"
  # t.string "text"

  belongs_to :member
  validates :level, :text, presence: true
end
