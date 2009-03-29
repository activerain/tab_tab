require 'tab_tab'

class ActionController::Base

  protected

  class << self
    include ::TabTab::ControllerMethods
  end

  include ::TabTab::ControllerMethods
  include ::TabTab::ControllerInstanceMethods
end

class ActionView::Base
  include ::TabTab::ViewHelpers
end
