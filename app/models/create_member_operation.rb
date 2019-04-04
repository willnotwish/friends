class CreateMemberOperation
  include ActiveModel::Model

  attr_accessor :name, :url

  validate :name, :url, presence: true

  def new_member
    Member.new name: name, url: url
  end

  def save
    return false unless valid?
    new_member.save.tap do |result|
      if result
        logger.debug "New member saved. Scheduling scrape headings job"
        ScrapeHeadingsJob.perform_later member
      end
    end
  end
end
