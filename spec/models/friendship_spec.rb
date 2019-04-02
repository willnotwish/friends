require 'rails_helper'

RSpec.describe Friendship, type: :model do
  it { is_expected.to be }
  it { is_expected.to belong_to(:member) }
  it { is_expected.to belong_to(:friend) }
end
