require File.join(File.dirname(__FILE__), 'test_helper')

class ViewTest < Test::Unit::TestCase

  def test_tab_scope_helper
    view            = YeOldeView.new
    view.controller = controller = StuffController.new

    simple = view.content_tag(:li, :id => 'admin_users_tab') do
      view.link_to('Users', '/admin/users/')
    end

    complex = view.content_tag(:li, :id => 'a_b_c_d_tab') do
      view.link_to('D', '/a/b/c/d/')
    end

    view.tabs_for :admin do |admin|
      assert_equal simple, admin.tab('/admin/users/', :users)
    end

    view.tabs_for :a => :b do |ab|
      assert_equal complex, ab.tab('/a/b/c/d/', ['c', 'd'])
    end
  end

  def test_of_builtin_tab_helper
    view            = YeOldeView.new
    view.controller = controller = StuffController.new

    minimal = view.content_tag(:li, :id => 'top_tab') do
      view.link_to('Top', '/')
    end

    nested = view.content_tag(:li, :id => 'top_under_lower_tab') do
      view.link_to('Lower', '/')
    end

    custom_css = view.content_tag(:li, :id => 'stuff_tab',
      :class => 'here') do

      view.link_to('Stuff', '/')
    end

    custom_name = view.content_tag(:li, :id => 'top_tab') do
      view.link_to('Back Home', '/')
    end

    custom_id = view.content_tag(:li, :id => 'top_tab', :id => '7p') do
      view.link_to('Top', '/')
    end

    custom_class = view.content_tag(:li, :id => 'top_tab', :class => '') do
      view.link_to('Top', '/')
    end

    assert_equal minimal,     view.tab('/', :top)
    assert_equal nested,      view.tab('/', :top => { :under => :lower })
    assert_equal custom_css,  view.tab('/', :stuff, :active_class => 'here')
    assert_equal custom_name, view.tab('/', :top,   :name => 'Back Home')
    assert_equal custom_id,   view.tab('/', :top,   :html => { :id => '7p' })
    assert_equal custom_class,
                 view.tab('/', :top, :html => { :class => '' })

    assert_raises ArgumentError do
      view.tab '/', :top, :invalid_key => 'Kaboom'
    end
  end

  def test_tab_helper_helper_with_invalid_keys
    view            = YeOldeView.new
    view.controller = controller = StuffController.new

    assert_raises ArgumentError do
      view.tab_helper_helper :stuff, :invalid_key => 'Kaboom'
    end
  end

  def test_tab_helper_helper_at_controller_level
    view            = YeOldeView.new
    view.controller = controller = StuffController.new

    html, literal_name, active_status = view.tab_helper_helper :stuff

    assert       active_status
    assert_equal 'Stuff',       literal_name
    assert_equal 'active', html[:class]
    assert_equal 'stuff_tab',   html[:id]
  end

  def test_tab_helper_helper_at_action_level
    view            = YeOldeView.new
    view.controller = controller = StuffController.new.edit

    html, literal_name, active_status = \
      view.tab_helper_helper :stuff => :edit

    assert       active_status
    assert_equal 'Edit',           literal_name
    assert_equal 'active',    html[:class]
    assert_equal 'stuff_edit_tab', html[:id]
  end

  def test_tab_helper_helper_with_not_active
    view            = YeOldeView.new
    view.controller = controller = StuffController.new.edit

    html, literal_name, active_status = view.tab_helper_helper :misc

    assert       !active_status
    assert_equal 'Misc',     literal_name
    assert_nil   html[:class]
    assert_equal 'misc_tab', html[:id]
  end

  def test_tab_helper_helper_preserving_given_html_id_and_class
    view            = YeOldeView.new
    view.controller = controller = StuffController.new

    html, literal_name, active_status = view.tab_helper_helper(:stuff,
      :html => { :id => 'bob', :class => 'super' })

    assert_equal 'super active', html[:class]
    assert_equal 'bob',               html[:id]
  end

  def test_of_custom_active_tab_class_name
    view            = YeOldeView.new
    view.controller = controller = StuffController.new

    html, literal_name, active_status = view.tab_helper_helper(:stuff,
      :active_class => 'selected', :html => { :class => 'tab' })

    assert_equal 'tab selected', html[:class]
  end

  def test_of_decorated_return_array
    view            = YeOldeView.new
    view.controller = controller = StuffController.new

    html, literal_name, active_status = view.tab_helper_helper :stuff
    return_array                      = view.tab_helper_helper :stuff

    assert_equal return_array.html,    html
    assert_equal return_array.name,    literal_name
    assert_equal return_array.active?, active_status
  end
end
