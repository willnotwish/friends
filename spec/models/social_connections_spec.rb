require 'rails_helper'

RSpec::Matchers.define :be_friends_with do |expected|
  match do |actual|
    actual.friends.include?(expected)
  end
end

RSpec.describe "Social connections" do
  context 'When three members - Alice, Bob & Carol - are added' do
    let!( :alice ) { FactoryBot.create( :member, name: 'Alice' ) }
    let!( :bob   ) { FactoryBot.create( :member, name: 'Bob'   ) }
    let!( :carol ) { FactoryBot.create( :member, name: 'Carol' ) }

    it 'Alice has no path to Bob' do
      expect(alice.shortest_path_to(bob)).to be_nil
    end

    context 'when Carol makes friends with Alice' do
      before do
        FactoryBot.create( :friendship_maker, member1: alice, member2: carol )
        expect(alice).to be_friends_with(carol)
      end

      it 'Alice has no path to Bob' do
        expect(alice.shortest_path_to(bob)).to be_nil
      end

      context 'when Carol makes friends with Bob' do
        before do
          FactoryBot.create( :friendship_maker, member1: bob, member2: carol )
          expect(carol).to be_friends_with(bob)
        end

        it "Alice's path to Bob involves three members" do
          expect(alice.shortest_path_to(bob)).to have(3).items
        end

        it "Alice's shortest path to Bob is via Carol" do
          expect(alice.shortest_path_to(bob)).to include(carol)
        end

        context 'when Carol is no longer friends with Bob' do
          before do
            FactoryBot.create( :friendship_breaker, member1: carol, member2: bob )
            expect(carol).not_to be_friends_with(bob)
          end

          it 'Alice has no path to Bob' do
            expect(alice.shortest_path_to(bob)).to be_nil
          end
        end
      end

      context 'when a new member - Dan - is friends with Carol and Bob' do
        let!( :dan ) { FactoryBot.create(:member, name: 'Dan') }
        before do
          FactoryBot.create( :friendship_maker, member1: dan, member2: carol )
          FactoryBot.create( :friendship_maker, member1: dan, member2: bob )
        end
        it "Alice's shortest path to Bob involves four members" do
          expect(alice.shortest_path_to(bob)).to have(4).items
        end
        it "Alice's shortest path to Bob involves Carol and Dan" do
          expect(alice.shortest_path_to(bob)).to include(carol, dan)
        end

        context 'when Carol makes friends with Bob' do
          before do
            FactoryBot.create( :friendship_maker, member1: bob, member2: carol )
            expect(carol).to be_friends_with(bob)
          end
          it "Alice's shortest path to Bob involves three members" do
            expect(alice.shortest_path_to(bob)).to have(3).items
          end
          it "Alice's shortest path to Bob involves Carol" do
            expect(alice.shortest_path_to(bob)).to include(carol)
          end
          it "Alice's shortest path to Bob does not involve Dan" do
            expect(alice.shortest_path_to(bob)).not_to include(dan)
          end
        end
      end
    end
  end
end