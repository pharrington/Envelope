class UidImageWhitelist < ActiveRecord::Base
  set_primary_key :uid
  belongs_to :user, :foreign_key => :user_email
end
