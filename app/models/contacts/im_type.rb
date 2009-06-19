class Contacts::IMType < ActiveRecord::Base
  include ::Contacts::ContactType

  AIM = find "AIM"
  Yahoo = find "Yahoo"
  GTalk = find "Google Talk"
  MSN = find "MSN"
  Jabber = find "Jabber"
  ICQ = find "ICQ"
  Other = find "Other"
end
