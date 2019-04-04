require 'rails_helper'

RSpec.describe HeadingsScraperService do
  # We're testing the public interface (a class method)
  subject { described_class }

  it { is_expected.to be }
  it { is_expected.to respond_to(:run!)}

  it 'raises an argument error when run with no member' do
    expect { subject.run!(nil) }.to raise_error(ArgumentError)
  end

  context 'with a member whose URL is example.com' do
    let( :url ) { 'example.com' }
    let( :member ) { FactoryBot.create( :member, url: url ) }

    it 'the member has no headings' do
      expect(member).to have(0).headings
    end

    it 'when run with that member as its only argument, it makes a call to HTTParty.get with example.com as its URL' do
      allow(HTTParty).to receive(:get).and_return double(body: "foo")
      expect(HTTParty).to receive(:get).with(url)
      subject.run! member
    end

    context 'when the html at example.com has seven headings' do

mock_html = <<-HTML
<!doctype html>
<html lang="en">
    <head>
        <meta charset="utf-8">
        <title>James</title>
    </head>
    <body>
        <h1>James' Website</h1>
        <h2>A refined filmography</h2>
        <h3>The Godfather</h3>
        <p>I rate it 9.2 out of 10.</p>
        <h3>The Shawshank Redemption</h3>
        <p>I rate it 9.3 out of 10.</p>
        <h3>Schindler's List</h3>
        <p>I rate it 8.9 out of 10.</p>
        <h3>Goldfinger</h3>
        <p>I rate it 8.7 out of 10.</p>
        <h3>Top Gear (BBC TV)</h3>
        <p>I rate it 0 out of 10.</p>
    </body>
</html>
HTML

      let( :html ) { mock_html }
      before do
        allow(HTTParty).to receive(:get).and_return double(body: mock_html)
      end

      it 'running the service should increase the number of headings that the member has from 0 to 7' do
        expect {subject.run!(member)}.to change {member.headings.count}.from(0).to(7)
      end

      it "having run the service, the member's headings should include 'Goldfinger'" do
        subject.run! member
        expect(member.headings.map(&:text)).to include('Goldfinger')
      end
    end
  end
end