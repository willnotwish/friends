# This serves as an example of a member decorator.

# In a production application it would be more comprehensive,
# maybe split into a base class and modules.

require 'shortest_friendship_path'

class MemberDecorator
  include ActiveModel::Model

  attr_accessor :member, :view_context

  delegate :content_tag, :link_to, to: :view_context

  delegate :name, :url, :short_url, :headings, to: :member

  def shortest_path_to( other )
    path = ShortestFriendshipPath.calculate member, other
    return '-' unless path
    content_tag( :nav ) do
      content_tag( :ul, nil ) do
        path.map do |m|
          content_tag :li, link_to( m.name, m )
        end.join( ' ' ).html_safe
      end
    end
  end

  def has_short_url?
    short_url.present?
  end

  def has_headings?
    headings.present?
  end

  def headings_as_ul
    content_tag( :ul, nil ) do
      headings.map do |h|
        content_tag :li, h.text
      end
    end
  end

  def has_friends?
    friends.present?
  end

  def friend_count
    friends.count
  end

  def friends_as_text
    friends.map(&:name).join(', ')
  end
end