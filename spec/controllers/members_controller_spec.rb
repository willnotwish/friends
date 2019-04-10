require 'rails_helper'

RSpec.describe MembersController, type: :controller do
  describe "GET #index" do
    before do
      get :index
    end

    it 'populates a collection of members' do
      expect(assigns(:members)).to be
    end

    it 'populates a search object of class MemberSearch' do
      expect(assigns(:search)).to be_a(MemberSearch)
    end

    context 'with no parameters' do
      it 'the MemberSearch has no criteria' do
        search = assigns(:search)
        expect(search.criteria).to be_blank
      end
    end

    context 'with a member_search hash containing some criteria as a parameter' do
      before do
        get :index, params: {member_search: { criteria: "foo" }}
      end

      it 'the search object has the same criteria' do
        search = assigns(:search)
        expect(search.criteria).to eq("foo")
      end
    end

    context 'with a member_search hash containing some unpermitted data as a parameter' do
      before do
        get :index, params: {member_search: { foo: "bar" }}
      end

      it 'the search object has no criteria' do
        search = assigns(:search)
        expect(search.criteria).to be_blank
      end
    end
  end

  context 'new or create' do
    let( :valid_params ) do
      { member: { name: 'foo', url: 'https://example.com/bar' } }
    end

    let( :misnamed_params_1 ) do
      { bad_member: { name: 'foo', url: 'https://example.com/bar' } }
    end

    let( :misnamed_params_2 ) do
      { member: { bad_name: 'foo', url: 'https://example.com/bar' } }
    end

    let( :misnamed_params_3 ) do
      { member: { name: 'foo', bad_url: 'https://example.com/bar' } }
    end

    describe "GET #new" do

      before do
        get :new
      end

      it 'assigns a new Member to @member' do
        expect(assigns(:member)).to be_a(Member)
      end

      it 'renders the new template' do
        expect(response).to render_template(:new)
      end
    end

    describe "POST #create" do

      before do
        allow( ScrapeHeadingsJob ).to receive(:perform_later)
        allow( ShortenUrlJob ).to receive(:perform_later)
      end

      it 'when called with some valid member params, the number of members is increased by 1' do
        expect { post :create, params: valid_params }.to change{ Member.count }.by( 1 )
      end

      it 'when called with some misnamed member params (1), the number of members is unchanged' do
        expect { post :create, params: misnamed_params_1 }.not_to change{ Member.count }
      end

      it 'when called with some misnamed member params (2), the number of members is unchanged' do
        expect { post :create, params: misnamed_params_2 }.not_to change{ Member.count }
      end

      it 'when called with some misnamed member params (3), the number of members is unchanged' do
        expect { post :create, params: misnamed_params_3 }.not_to change{ Member.count }
      end

      context 'background job scheduling' do
        it 'when called with valid params a ScrapeHeadings job should be scheduled with a Member as an argument' do
          expect(ScrapeHeadingsJob).to receive(:perform_later).with(kind_of(Member))
          post :create, params: valid_params
        end
        it 'when called with invalid params a ScrapeHeadings job should not be scheduled' do
          expect(ScrapeHeadingsJob).not_to receive(:perform_later)
          post :create, params: misnamed_params_1
        end
        it 'when called with valid params a ShortenUrlJob job should be scheduled with a Member as an argument' do
          expect(ShortenUrlJob).to receive(:perform_later).with(kind_of(Member))
          post :create, params: valid_params
        end
        it 'when called with invalid params a ShortenUrlJob job should not be scheduled' do
          expect(ShortenUrlJob).not_to receive(:perform_later)
          post :create, params: misnamed_params_1
        end
      end
    end
  end
end