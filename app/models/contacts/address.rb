module Contacts
  class Address < ActiveRecord::Base
    set_table_name 'contacts_addresses'
    belongs_to :contact
  end
end
