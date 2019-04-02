class Member < ApplicationRecord
  # t.string "name"
  # t.string "url"
  # t.string "short_url"
  has_many :headings

  has_many :friendships
  has_many :friends, class_name: "Member", through: :friendships

  validates :name, presence: true
  validates :url, presence: true, uniqueness: { case_sensitive: false }
  validates :short_url, uniqueness: { case_sensitive: false, allow_blank: true }
end