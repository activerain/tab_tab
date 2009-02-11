$:.unshift(File.dirname(__FILE__) + '/../')
require 'rubygems'
require 'active_support'
require 'active_support/test_case'
require 'action_controller'
require 'action_view'
require 'action_view/helpers'
require 'init'

begin
  require 'ruby-debug'
rescue LoadError
  puts "Install 'ruby-debug' to use the debugger during tests"
end

begin
  require 'redgreen'
rescue LoadError
  puts "Install 'redgreen' to get color output during tests"
end unless ENV['TM_BUNDLE_PATH']

class Test::Unit::TestCase
  require File.join(File.dirname(__FILE__), 'fixtures', 'ye_olde_view')
  require File.join(File.dirname(__FILE__), 'fixtures', 'bars_controller')
  require File.join(File.dirname(__FILE__), 'fixtures', 'stuff_controller')
end

def assert_activation(tab, *other_tab)

  tab, other_tab = Tab[tab], Tab[other_tab]

  assert_block "#{tab.inspect} does not activate #{other_tab.inspect}" do
    tab.activates? other_tab
  end
end

def assert_no_activation(tab, *other_tab)

  tab, other_tab = Tab[tab], Tab[other_tab]

  assert_block "#{tab.inspect} activates #{other_tab.inspect}" do
    not tab.activates? other_tab
  end
end