class User < ActiveRecord::Base
  include Attachable

  attr_accessible :email
  set_primary_key :email
  has_many :contacts, :class_name => "::Contacts::Contact", :foreign_key => "user"
  has_many :uid_image_whitelists, :foreign_key => "user_email"
  has_many :email_address_image_whitelists, :foreign_key => "user_email"
  has_one :settings, :foreign_key => "user_email", :dependent => :destroy

  acts_as_authentic
  def valid_password?(pass); true; end

  def update_contacts(email)
    return if email[","]
    unless contacts.first :joins => [ :emails ], :conditions => { "contacts_emails.email" => email }
      contact = Contacts::Contact.new(:name => email)
      contact.emails_attributes = [ { :email => email, :type => "Work" } ]
      contacts << contact
    end
  end

  def display_name
    settings.name rescue nil
  end
end
