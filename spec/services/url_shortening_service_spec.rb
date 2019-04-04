require 'rails_helper'

RSpec.describe UrlShorteningService do
  # We're testing the public interface (a class method)
  subject { described_class }

  it { is_expected.to be }
  it { is_expected.to respond_to(:run!)}

  it 'raises an argument error when run with no member' do
    expect { subject.run!(nil) }.to raise_error(ArgumentError)
  end
end