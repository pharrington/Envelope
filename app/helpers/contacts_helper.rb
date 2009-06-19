module ContactsHelper
  def attributes_locals(string)
    { :legend => string,
      :collection => @contact.send(string.downcase.pluralize.to_sym),
      :new_object => "Contacts::#{string}".constantize.new,
    }
  end
end
