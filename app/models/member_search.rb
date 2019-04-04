class MemberSearch
  include ActiveModel::Model

  attr_accessor :criteria

  def filter( scope )
    if criteria.present?
      scope.with_heading_containing( criteria )
    else
      scope
    end
  end
end