#Less painful use of helper methods in models and controllers
class Helper
  include ActionView::Helpers::SanitizeHelper
  include ERB::Util
  include EmailHelper
  extend ActionView::Helpers::SanitizeHelper::ClassMethods

  def initialize controller
    @controller = controller
  end

  def method_missing(method, *args)
    if method.to_s =~ /^.+(?:_path|_url)$/ #named route helpers
      @controller.send(method, *args)
    else
      super
    end
  end
end
