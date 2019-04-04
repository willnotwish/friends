class UrlShorteningService

  # public API
  def self.run!( member )
    new( member ).shorten_url!
  end

  attr_reader :member

  def initialize(m)
    @member = m
    raise ArgumentError.new('Member must be specified') unless @member
  end

  def shorten_url!
    Rails.logger.debug "TODO. Shorten URL #{member.url}"
  end
end