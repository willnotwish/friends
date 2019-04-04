class ScrapeHeadingsJob < ApplicationJob
  queue_as :default

  def perform(member)
    HeadingsScraperService.run! member
  end
end
