#provides mass assignment functionality to non-ActiveRecord models
module MassAssignable
  def self.included(base)
    base.extend ClassMethods
    base.send :include, InstanceMethods
  end
  module ClassMethods
    def attr_accessible(*attributes)
      attributes.each do |attribute|
        self.class_eval do
          attr_accessor attribute unless respond_to? attribute
        end
      end
      class << self
        attr_accessor :assignable_attributes
      end
      self.assignable_attributes = attributes
    end
  end
  module InstanceMethods
    def initialize(hash)
      return unless self.class.respond_to? :assignable_attributes
      hash.each do |key, value|
        if self.class.assignable_attributes.include? key.to_sym and respond_to? "#{key}=" then
          send "#{key}=".to_sym, value
        end
      end
    end
  end
end
