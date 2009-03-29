module TabTab
  module ViewHelpers
    # Draws an HTML list tag with a link inside, linking to the given URL.
    #
    # +opts+ can contain:
    # - +:name+: the human name of the tab
    # - +:html+: a hash of HTML attributes (namely :id and :class)
    #
    def tab(url, tab_literal, opts = {})
      opts = (opts || {}).to_options
      opts.assert_valid_keys :html, :name

      name = opts[:name] || tab_name_helper(tab_literal)

      html = tab_html_attributes_helper(tab_literal, opts[:html])

      content_tag(:li, html) { link_to(name, url) }
    end

    # Returns the human name for the given tab literal.
    #
    def tab_name_helper(tab_literal) #:nodoc:
      Tab.new(tab_literal).name
    end

    # Returns the given +html_attributes+ back, with 'active' added to the
    # +:class+ attribute if the given +tab_literal+ is currently active, and
    # with an auto-generated +:id+ attribute if none is provided.
    #
    def tab_html_attributes_helper(tab_literal, html_attributes = {})
      html = (html_attributes || {}).to_options
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