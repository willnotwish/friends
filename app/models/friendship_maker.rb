class FriendshipMaker
  include ActiveModel::Model
  attr_accessor :member1, :member2

  validates :member1, :member2, presence: true

  # TODO. Add validation
  # => that they are not the same member
  # => that they are existing members
  # => that they are not already friends

  # Quacks like AR
  def save
    return false unless valid?
    Friendship.create( member: member1, friend: member2 ) && Friendship.create( member: member2, friend: member1 )
  end

  def save!
    raise "Unable to make friendship" unless save
  end
end
