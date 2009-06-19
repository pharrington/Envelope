class Contacts::EmailType < ActiveRecord::Base
  include ::Contacts::ContactType

  Work = find "Work"
  Personal = find "Personal"
  Other = find "Other"
end
