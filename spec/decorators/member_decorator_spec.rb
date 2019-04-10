require 'rails_helper'

RSpec.describe MemberDecorator do
  include ActionView::TestCase::Behavior

  it {is_expected.to respond_to(:member)}
  it {is_expected.to respond_to(:member=)}

  it {is_expected.to respond_to(:view_context)}
  it {is_expected.to respond_to(:view_context=)}

  it {is_expected.to delegate_method(:content_tag).to(:view_context)}
  it {is_expected.to delegate_method(:link_to).to(:view_context)}

  context 'When three members - Alice, Bob & Carol - are added' do
    let!( :alice ) { FactoryBot.create( :member, name: 'Alice' ) }
    let!( :bob   ) { FactoryBot.create( :member, name: 'Bob'   ) }
    let!( :carol ) { FactoryBot.create( :member, name: 'Carol' ) }

    let( :view_context ) { view }

    before do
      subject.view_context = view_context
    end

    it 'the shortest path from Alice to Bob is represented as a single dash' do
      subject.member = alice
      expect(subject.shortest_path_to(bob)).to eq('-')
    end

    context 'when Carol makes friends with Alice' do
      before do
        FactoryBot.create( :friendship_maker, member1: alice, member2: carol )
      end

      it 'the shortest path from Alice to Bob is represented as a single dash' do
        subject.member = alice
        expect(subject.shortest_path_to(bob)).to eq('-')
      end

      context 'when Carol makes friends with Bob' do
        before do
          FactoryBot.create( :friendship_maker, member1: bob, member2: carol )
        end

        context "Alice's shortest path to Bob"  do
          before do
            subject.member = alice
          end

          let( :path ) { subject.shortest_path_to(bob)}

          it 'contains one ul tag' do
            expect(path).to match /ul/
          end

          it 'contains three li tags' do
            expect(path).to match /li.*li.*li/
          end

          it 'contains the text Alice, Carol and Bob in that order' do
            expect(path).to match /Alice.*Carol.*Bob/
          end
        end
      end
    end
  end
end