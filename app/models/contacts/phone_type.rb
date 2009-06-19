class Contacts::PhoneType < ActiveRecord::Base
  include ::Contacts::ContactType

  Work = find "Work"
  Mobile = find "Mobile"
  Fax = find "Fax"
  Home = find "Home"
  Other = find "Other"
end
