class EmailAddressImageWhitelist < ActiveRecord::Base
  set_primary_key :email
  belongs_to :user, :foreign_key => :user_email
end
