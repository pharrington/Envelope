class UserSession < Authlogic::Session::Base
  def save(&block)
    begin
      imap = PMail::IMAP.new(:host => 'badenoughdu.de', :user => email, :pass => protected_password)
      imap.disconnect
    rescue
      return false
    end
    
    #create user in DB if this is the first time logging in
    user = klass.find_or_create_by_email(email)
    return false if !user

    self.unauthorized_record = user
    controller.session['id'] = Authlogic::Random.hex_token.to_sym
    self.id = controller.session['id']

    #cache IMAP connection on successful login
    imap_connection 

    super
  end

  def destroy
    #controller.imap.delete(self.id)
    controller.imap_proxy.delete(self.id)
  end

  def imap_connection
    controller.imap_proxy.login(self.id, email, protected_password)
  end
end
