require 'rails_helper'
require 'shortest_friendship_path'

RSpec::Matchers.define :be_friends_with do |expected|
  match do |actual|
    actual.friends.include?(expected)
  end
end

RSpec.describe "Social connections" do
  context "When three members - Alice, Bob & Carol - are added, Alice's connection to Bob" do
    let!( :alice ) { FactoryBot.create( :member, name: 'Alice' ) }
    let!( :bob   ) { FactoryBot.create( :member, name: 'Bob'   ) }
    let!( :carol ) { FactoryBot.create( :member, name: 'Carol' ) }

    subject { ShortestFriendshipPath.calculate(alice, bob) }

    it { is_expected.to be_nil }

    context "when Carol makes friends with Alice, Alice's connection to Bob" do
      before do
        FactoryBot.create( :friendship_maker, member1: alice, member2: carol )
        expect(alice).to be_friends_with(carol)
      end

      it { is_expected.to be_nil }

      context "when Carol makes friends with Bob, Alice's connection to Bob" do
        before do
          FactoryBot.create( :friendship_maker, member1: bob, member2: carol )
          expect(carol).to be_friends_with(bob)
        end

        it { is_expected.to have(3).items }
        it { is_expected.to include(carol) }

        context "when Carol is no longer friends with Bob, Alice's connection to Bob" do
          before do
            FactoryBot.create( :friendship_breaker, member1: carol, member2: bob )
            expect(carol).not_to be_friends_with(bob)
          end
          it { is_expected.to be_nil }
        end
      end

      context "when a new member - Dan - is friends with Carol and Bob, Alice's connection to Bob" do
        let!( :dan ) { FactoryBot.create(:member, name: 'Dan') }
        before do
          FactoryBot.create( :friendship_maker, member1: dan, member2: carol )
          FactoryBot.create( :friendship_maker, member1: dan, member2: bob )
        end
        it { is_expected.to have(4).items }
        it { is_expected.to include(carol, dan) }

        context "when Carol makes friends with Bob, Alice's connection to Bob" do
          before do
            FactoryBot.create( :friendship_maker, member1: bob, member2: carol )
            expect(carol).to be_friends_with(bob)
          end
          it { is_expected.to have(3).items }
          it { is_expected.to include(carol) }
          it { is_expected.not_to include(dan) }
        end
      end
    end
  end
end