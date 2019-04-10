class ApplicationDecorator
  include ActiveModel::Model

  attr_accessor :object, :view_context

  delegate :id, to: :object, allow_nil: true
  delegate :to_model, to: :object   # allows url generation to work as expected
  delegate :content_tag, :link_to, to: :view_context
end