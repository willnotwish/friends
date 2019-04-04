class MembersController < ApplicationController

  def index
    @members = Member.all.order( :name )
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
      ScrapeHeadingsJob.perform_later @member
      ShortenUrlJob.perform_later @member
    end
    respond_with @member
  end

private

  def member_params
    params.fetch( :member, {} ).permit( :name, :url )
  end
end