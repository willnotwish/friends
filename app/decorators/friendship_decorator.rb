class FriendshipDecorator
  include ActiveModel::Model

  attr_accessor :source, :target, :view_context

  delegate :content_tag, :link_to, to: :view_context

  cattr_accessor(:logger) { Rails.logger }

  def shortest_path
    path = BreadthFirstSearch.new( source ).shortest_path_to( target )
    logger.debug "Shortest path: #{path}"
    return unless path
    content_tag( :ul, nil, class: 'breadcrumb' ) do
      path.map do |m|
        content_tag :li, link_to( m.name, m )
      end.join( ' ' ).html_safe
    end
  end

  # Search algorithm. This could be somewhere else... (in an external library perhaps)

  # Put unvisited nodes on a queue
  # Solves the shortest path problem: Find path from "source" to "target"
  # that uses the fewest number of edges
  # It's not recursive (like depth first search)
  #
  # The steps are quite simple:
  # * Put s into a FIFO queue and mark it as visited
  # * Repeat until the queue is empty:
  #   - Remove the least recently added node n
  #   - add each of n's unvisited adjacents to the queue and
  #     mark them as visited

  class BreadthFirstSearch
    def initialize(source_node)
      @node = source_node
      @visited = []
      @edge_to = {}

      traverse(source_node)
    end

    def shortest_path_to(node)
      return unless has_path_to?(node)
      path = []

      while(node != @node) do
        path.unshift(node) # unshift adds the node to the beginning of the array
        node = @edge_to[node]
      end

      path.unshift(@node)
    end

  private
    def traverse(node)
      # Remember, in the breadth first search we always
      # use a queue. In ruby we can represent both
      # queues and stacks as an Array, just by using
      # the correct methods to deal with it. In this case,
      # we use the "shift" method to remove an element
      # from the beginning of the Array.

      # First step: Put the source node into a queue and mark it as visited
      queue = []
      queue << node
      @visited << node

      # Second step: Repeat until the queue is empty:
      # - Remove the least recently added node n
      # - add each of n's unvisited adjacents to the queue and mark them as visited
      while queue.any?
        current_node = queue.shift # remove first element
        current_node.friends.each do |adjacent_node|
          next if @visited.include?(adjacent_node)
          queue << adjacent_node
          @visited << adjacent_node
          @edge_to[adjacent_node] = current_node
        end
      end
    end

    # If we visited the node, so there is a path
    # from our source node to it.
    def has_path_to?(node)
      @visited.include?(node)
    end
  end
end