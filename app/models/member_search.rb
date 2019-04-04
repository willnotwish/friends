class MemberSearch
  include ActiveModel::Model

  attr_accessor :criteria
  # attr_accessor :member # optional

  def filter( scope )
    if criteria.present?
      logger.debug "About to filter using criteria: #{criteria}"
      scope.with_heading_containing( criteria ).tap {|q| logger.debug("MemberSearch. query: #{q.to_sql}")}
    else
      scope
    end
  end

  cattr_accessor( :logger ) { Rails.logger }
end
