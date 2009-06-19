module Contacts
  class Email < ActiveRecord::Base
    set_table_name "contacts_emails"
    belongs_to :contact
    set_inheritance_column "sti_type"

    attr_accessible :email, :type

    validates_presence_of :email
  end
end
