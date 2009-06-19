class Contacts::AddressType < ActiveRecord::Base
  include ::Contacts::ContactType

  Work = find "Work"
  Home = find "Home"
  Other = find "Other"
end
