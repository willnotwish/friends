class Heading < ApplicationRecord
  # t.integer "level"
  # t.string "text"

  belongs_to :member
  validates :level, :text, presence: true

  class << self
    def contains( text )
      logger.debug "contains: #{text}"
      where( arel_table[:text].matches("%#{text}%") ).tap { |clause| logger.debug "Clause: #{clause.to_sql}"}
    end
  end
end
