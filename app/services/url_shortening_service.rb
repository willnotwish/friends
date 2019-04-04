class UrlShorteningService

  API_ENDPOINT = "https://api.rebrandly.com/v1/links"

  cattr_accessor( :logger ) { Rails.logger }

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
    headers = {
      "apikey": Rails.application.credentials.dig(:rebrandly_api_key),
      "content-type": "application/json"
    }
    payload = {
      destination: member.url,
      domain: { fullName: "rebrand.ly" }
    }
    logger.debug "body: #{payload}"
    response = HTTParty.post( API_ENDPOINT,
      headers: headers,
      debug_output: STDOUT,
      body: payload.to_json )
    logger.debug "Response from #{API_ENDPOINT} is: #{response}"
    member.update! short_url: response["shortUrl"]
  end
end