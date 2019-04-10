# This serves as an example of a member decorator.

# In a production application it would be more comprehensive,
# maybe split into modules.

require 'shortest_friendship_path'

class MemberDecorator < ApplicationDecorator

  delegate :id, :name, :url, :short_url, :headings, :friends, to: :object

  def shortest_path_to( other )
    path = ShortestFriendshipPath.calculate object, other
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
    headings.any?
  end

  def headings_as_ul
    content_tag( :ul, nil ) do
      headings.map do |h|
        content_tag :li, h.text
      end.join( ' ' ).html_safe
    end
  end

  def headings_as_text
    headings.map(&:text).join(', ')
  end

  def has_friends?
    friends.any?
  end

  def friend_count
    friends.count
  end
  alias_method :friends_count, :friend_count

  def friends_as_text
    friends.map(&:name).join(', ')
  end
end