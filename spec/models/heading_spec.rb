require 'rails_helper'

RSpec.describe Heading, type: :model do
  it { is_expected.to be }

  it { is_expected.to belong_to(:member) }
end
