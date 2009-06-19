module Contacts::ContactType
  def self.included(base)
    base.set_inheritance_column :sti_type
    base.set_primary_key :type
  end
end
