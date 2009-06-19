# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  before_filter :start_drb, :verify_session
  after_filter :stop_drb
  helper :all # include all helpers, all the time
  helper_method :current_user_session, :current_user, :imap, :top_contacts
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  # Scrub sensitive parameters from your log
  filter_parameter_logging :password

  private
    def start_drb
      DRb.start_service
      @imap_proxy = DRbObject.new(nil, "druby://localhost:37278")
    end

    def stop_drb
      DRb.stop_service
    end

    def imap
      @imap_proxy.cached(session['id'])
    end

    def imap_proxy
      @imap_proxy
    end

    def mailbox
      session['mailbox'] ||= 'inbox'
      @mailbox ||= imap.select session['mailbox']
    end

    def current_user_session
      return @current_user_session if defined?(@current_user_session)
      @current_user_session = UserSession.find(session['id'])
    end

    def current_user
      return @current_user if defined?(@current_user)
      @current_user = current_user_session && current_user_session.user
    end

    def require_user
      unless current_user
        stop_drb
        flash[:notice] = "You must be logged in to view this page"
        redirect_to_and_remember login_path
        return false
      end
    end

    def redirect_to_and_remember(uri)
      session[:last_page] = request.request_uri
      redirect_to uri
    end

    def redirect_back_or_to(uri)
      if session[:last_page]
        redirect_to session[:last_page]
      else
        redirect_to uri
      end
    end

    #provide sane default values for the session
    def session_defaults
      session['attachment_count'] ||= 0
    end

    def require_no_user
      if current_user
        flash[:notice] = "You must be logged out first."
        redirect_to email_path
        return false
      end
    end
    #check session['id'], and if the corresponding key is in the cache
    #if not, reset the session
    def verify_session
      reset_session if session['id'] && !@imap_proxy.cached?(session['id'])
      session_defaults
    end

    def top_contacts
      current_user.contacts.paginate :include => :emails, :per_page => 8, :page => 1, :order => "contacts.created_at ASC"
    end
end
