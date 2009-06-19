class Settings < ActiveRecord::Base
  set_primary_key :user_email
  belongs_to :user, :foreign_key => :user_email

  attr_accessible :name, :signature, :signature_enabled
end
