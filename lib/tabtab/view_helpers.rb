module TabTab
  module ViewHelpers
    # The tab helper. Draws an HTML list tag with a link inside, linking to
    # the given URL.
    #
    # +opts+ can contain:
    # - +:name+: the human name of the tab
    # - +:html+: a hash of HTML attributes (namely :id and :class)
    #
    def tab(url, tab_literal, opts = nil)
      opts = (opts || {}).to_options
      opts.assert_valid_keys :html, :name

      name = opts[:name] || tab_name_helper(tab_literal)
      html = tab_html_helper(tab_literal, opts[:html])

      content_tag(:li, html) { link_to(name, url) }
    end

    def tab_name_helper(tab_literal) #:nodoc:
      Tab.new(tab_literal).name
    end

    def tab_html_helper(tab_literal, html = nil) #:nodoc:
      html = (html || {}).to_options
      tab  = Tab.new(tab_literal)

      if controller.current_tab.activates?(tab)
        html[:class] = [ (html[:class] || ''), 'active' ].join(' ').lstrip
      end

      html[:id] ||= tab.html_id

      html
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