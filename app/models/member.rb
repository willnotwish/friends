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

  class << self
    def with_heading_containing( text )
      joins( :headings ).merge Heading.contains( text )
    end

    def potential_friends_of( member )
      # Could do this with a left join, but still
      ids = member.friends.pluck(:id)
      ids.push member.id
      where.not( id: ids )
    end
  end
end
