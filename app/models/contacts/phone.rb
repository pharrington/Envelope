module Contacts
  class Phone < ActiveRecord::Base
    set_table_name "contacts_phones"
    belongs_to :contact
  end
end
