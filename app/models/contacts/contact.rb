class Contacts::Contact < ActiveRecord::Base
  has_many :emails, :class_name => "::Contacts::Email", :dependent => :delete_all
  has_many :phones, :class_name => "::Contacts::Phone", :dependent => :delete_all
  has_many :addresses, :class_name => "::Contacts::Address", :dependent => :delete_all
  has_many :ims, :class_name => "::Contacts::IM", :dependent => :delete_all
  belongs_to :user, :class_name => "::User", :foreign_key => "user"

  def self.reject(attributes)
    %w[email number address handle].each do |key|
      return attributes[key].blank? if attributes.has_key? key 
    end
  end

  accepts_nested_attributes_for :emails, :phones, :addresses, :ims, :allow_destroy => true, :reject_if => method(:reject)
end
