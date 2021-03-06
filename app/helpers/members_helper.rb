module MembersHelper
  # Maybe enhance this to accept a collection, as well as a single model
  def decorate( member )
    MemberDecorator.new( object: member, view_context: self ).tap do |dm|
      yield dm if block_given?
    end
  end
end
