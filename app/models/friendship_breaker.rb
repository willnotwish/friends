class FriendshipBreaker
  include ActiveModel::Model
  attr_accessor :member1, :member2

  validates :member1, :member2, presence: true

  # TODO. Add validation
  # => that they are not the same member
  # => that they are existing members
  # => that they are already friends

  # Quacks like AR
  def save
    return false unless valid?
    Friendship.where( member: member1, friend: member2 ).delete_all
    Friendship.where( member: member2, friend: member1 ).delete_all
    true
  end

  def save!
    raise "Unable to break friendship" unless save
  end
end
