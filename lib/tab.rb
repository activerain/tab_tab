module TabTab #:nodoc:
  class Tab #:nodoc:
    attr_accessor :nested_path #:nodoc:

    def self.[](*args, &block) #:nodoc:
      new *args, &block
    end

    def ==(other) #:nodoc:
      self.nested_path == other.nested_path
    end

    # Creates a new Tab object. Takes a symbol (or string), or an array of
    # symbols, or a single key hash of single key hashes, where both keys and
    # values are symbols. Like so:
    #
    # Tab.new :invoices
    #
    # Or, for nested tabs:
    #
    # Tab.new { :administration => { :requests => :pending_approval }
    # Tab.new [ 'administration', 'requests', 'pending_approval' ]
    #
    def initialize(*args)
      if args.flatten.first.is_a? Hash
        self.nested_path = []

        deep_keys = args.flatten.first.clone

        while deep_keys.is_a? Hash
          next_key = deep_keys.keys.first
          self.nested_path << next_key.to_s
          deep_keys = deep_keys[next_key]
        end

        self.nested_path << deep_keys.to_s # Last key

      else
        self.nested_path = args.flatten.collect { |p| p.to_s }
      end
    end

    # Returns the auto-generated HTML id for the tab element, by joining
    # the nested tab IDs with underscores, and adding '_tab' at the end.
    #
    def html_id
      ([ self.nested_path ] + [ 'tab' ]).join '_'
    end

    # Returns the auto-generated name (caption) for a tab, inferring it from
    # the deepest part of a nested tab identifier.
    #
    def name
      self.nested_path.last.titlecase
    end

    # Deep, nested tabs activate themselves, and their ancestors. For example:
    #
    # users_tab    = Tab.new :users
    # inactive_tab = Tab.new :users => :inactive
    #
    # inactive_tab.activates?(users_tab) => true
    #
    # The idea being that when the current tab is that of inactive users, both
    # the inactive users tab and the users tab will appear as the current tab.
    #
    def activates?(other)
      other.nested_path == nested_path[0..other.nested_path.size-1]
    end
  end
end