require 'rails_helper'

RSpec.describe Member, type: :model do
  it { is_expected.to be }
  it { is_expected.to have_many(:headings) }
  it { is_expected.to have_many(:friendships) }
  it { is_expected.to have_many(:friends) }

  it { is_expected.to validate_presence_of(:name) }

  it { is_expected.to validate_uniqueness_of(:url).case_insensitive }
  it { is_expected.to validate_presence_of(:url) }

  it { is_expected.to validate_uniqueness_of(:short_url).case_insensitive }

  it { is_expected.to have(0).friends }
end