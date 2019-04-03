require 'rails_helper'

RSpec::Matchers.define :be_friends_with do |expected|
  match do |actual|
    actual.friends.include?(expected)
  end
end

RSpec.describe "Making friends" do
  context 'When one member - Alice - exists' do
    let!( :alice ) { FactoryBot.create(:member, name: 'Alice') }

    it 'Alice has no friends' do
      expect(alice).to have(0).friends
    end

    context 'when a second member - Bob - is added' do
      let!( :bob ) { FactoryBot.create(:member, name: 'Bob') }

      it 'Bob has no friends' do
        expect(alice).to have(0).friends
      end

      context 'when Carol is added as a friend of both Alice and Bob' do
        let!(:carol) { FactoryBot.create( :member, name: 'Carol' )}

        before do
          FactoryBot.create( :friendship_maker, member1: alice, member2: carol )
          FactoryBot.create( :friendship_maker, member1: bob,   member2: carol )
        end

        it 'Alice has one friend' do
          expect(alice).to have(1).friend
        end

        it 'Bob has one friend' do
          expect(bob).to have(1).friend
        end

        it 'Carol has two friends' do
          expect(carol).to have(2).friends
        end

        it "Alice is friends with Carol" do
          expect(alice).to be_friends_with(carol)
        end

        it "Carol is friends with Alice" do
          expect(carol).to be_friends_with(alice)
        end

        it "Carol is friends with Bob" do
          expect(carol).to be_friends_with(bob)
        end

        context "when Carol decides not to be friends with Alice" do
          before do
            FactoryBot.create( :friendship_breaker, member1: carol, member2: alice )
          end
          it "Carol is not friends with Alice" do
            expect(carol).not_to be_friends_with(alice)
          end
        end

        it "Breaking the friendship between Bob and Carol decreases Carol's friendships by one" do
          expect {FactoryBot.create( :friendship_breaker, member1: bob, member2: carol )}.to change {bob.friends.count}.by(-1)
        end
      end
    end
  end
end