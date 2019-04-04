class MembersController < ApplicationController

  def index
    @search = MemberSearch.new member_search_params
    @members = @search.filter Member.all.order( :name ).includes( :headings )
    respond_with @members
  end

  def show
    @member = Member.find params[:id]
    respond_with @member
  end

  def new
    @member = Member.new member_params
    respond_with @member
  end

  def create
    @member = Member.new member_params
    if @member.save
      # I considered adding these as on_create hooks in the Member model.
      # Really, they should be in a separate operation-style class.
      # But for now, that's overkill, so I've added them here.
      ScrapeHeadingsJob.perform_later @member
      ShortenUrlJob.perform_later @member
    end
    respond_with @member
  end

private

  def member_params
    params.fetch( :member, {} ).permit( :name, :url )
  end

  def member_search_params
    params.fetch( :member_search, {} ).permit( :criteria )
  end
end