class Contacts::IM < ActiveRecord::Base
  set_table_name 'contacts_ims'
  belongs_to :contact
  set_inheritance_column 'sti_type'

  attr_accessible :handle, :type
end
