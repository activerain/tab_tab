module TabTab
  module ViewHelpers
    module TabHelperHelperReturnDecoration #:nodoc:
      def html;    first;  end #:nodoc:
      def name;    second; end #:nodoc:
      def active?; third;  end #:nodoc:
    end

    # The tab helper. Draws an HTML list tag with a link inside, linking to
    # the given URL.
    #
    # +opts+ can contain:
    # - +:name+: the human name of the tab
    # - +:html+: a hash of HTML attributes (namely :id and :class)
    # - +:active_class+: the CSS class name you want tacked on active tabs
    #
    def tab(url, tab_literal, opts = nil)
      opts = (opts || {}).to_options
      opts.assert_valid_keys :active_class, :html, :name

      name = opts.delete :name # tab_helper_helper doesn't like :name
      help = tab_helper_helper(tab_literal, opts)

      content_tag(:li, help.html) { link_to((name || help.name), url) }
    end

    # This helper helper (ugh) method is used by the +tab+ helper to modify
    # the HTML attributes in case the tab is "active".
    #
    # +tab_literal+ is of the same types of literal you pass to the +tab+
    # method on the controllers.
    #
    # +opts+ can contain:
    # - +:html+: a hash of HTML attributes (namely :id and :class)
    # - +:active_class+: the CSS class name you want tacked on active tabs
    #
    # It returns a duck that responds to a few methods:
    # - +html+: A clone of +opts[:html]+ with adjusted +:class+
    # - +name+: A human name suggestion for the tab
    # - +active?+: Returns true if the given tab literal is active right now
    #
    def tab_helper_helper(tab_literal, opts = nil)
      opts = (opts || {}).to_options
      opts.assert_valid_keys :active_class, :html

      tab          = Tab.new(tab_literal)
      html         = (opts[:html] || {}).to_options
      active_class = opts[:active_class].blank? ? 'active' \
                                                : opts[:active_class]
      html[:id]  ||= tab.html_id
      tab_active   = controller.current_tab.activates?(tab)

      if tab_active
        html[:class] = \
          [ (html[:class] || ''), active_class.to_s ].join(' ').lstrip
      end

      [ html, tab.name, tab_active ].extend TabHelperHelperReturnDecoration
    end

    # Use in your views when you need to render several tabs with similar
    # nested levels, like so:
    #
    #   <ul id="warehouse_tabs">
    #     <% tabs_for :warehouse do |warehouse| %>
    #       <%= warehouse.tab('/foo', :projections) -%>
    #       <%= warehouse.tab('/bar', :capacity)    -%>
    #     <% end %>
    #   </ul>
    #
    def tabs_for(*tab_literal_scope, &block)
      scope      = Scope.new
      scope.path = Tab.new(tab_literal_scope).nested_path
      scope.view = self

      block.call scope
    end
  end
end