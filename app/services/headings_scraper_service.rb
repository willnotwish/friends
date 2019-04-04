class HeadingsScraperService

  # public API
  def self.run!( member )
    new( member ).scrape!
  end

  attr_reader :member

  def initialize(m)
    @member = m
    raise ArgumentError.new('Member must be specified') unless @member
  end

  def scrape!
    doc = Nokogiri::HTML(HTTParty.get(member.url).body)
    [1, 2, 3].each do |level|
      doc.css("h#{level}").each do |h|
        member.headings.create! level: level, text: h.text
      end
    end
  end
end