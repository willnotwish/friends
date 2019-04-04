class ShortenUrlJob < ApplicationJob
  queue_as :default

  def perform(member)
    UrlShorteningService.run! member
  end
end
