class EmailsController < ApplicationController
  uses_tiny_mce :options => {
    :theme => "advanced",
    :plugins => %w[ safari inlinepopups contextmenu noneditable nonbreaking simpleimage ],
    :theme_advanced_buttons1 => %w[ bold italic underline strikethrough | justifyleft justifycenter justifyright fontselect fontsizeselect | bullist numlist | outdent indent blockquote | undo redo | link unlink simpleimage | forecolor backcolor removeformat | hr ],
    :theme_advanced_buttons2 => "",
    :theme_advanced_buttons3 => "",
    :theme_advanced_toolbar_location => "top",
    :theme_advanced_toolbar_align => "left",
    :theme_advanced_resizing => false,
    :visual => false,
  }, :only => [:new, :reply, :forward]
  before_filter :require_user

  def index
    seqnos = params[:q] ? mailbox.seqnos(params[:q]) : mailbox.seqnos
    @messages = mailbox.fetch_envelopes(seqnos).reverse
  end

  def new
    settings = current_user.settings
    if settings && settings.signature_enabled?
      params.merge! :body => <<END
<br /><br />
---
#{settings.signature}
END
    end
    @email = Email.new(current_user, helper, params)
  end

  def create
    @email = Email.new(current_user, helper, params[:email])
    current_user.update_contacts @email.to
    @email.mailbox = mailbox
    @email.deliver imap.user, imap.password
    flash[:notice] = "Message sent."
    redirect_to emails_path
  end

  def update
  end

  def show
    message = mailbox.fetch_message(uid)
    @email = process_message(message, message.subject, '', message.to)
    @email.from = message.from
    @attachments = message.attachments
    @content = params[:raw] ? helper.clean_plain(mailbox.fetch_raw(uid)) : @email.body
    set_charset(message.charset)
  end

  def destroy
    mailbox.delete_message(uid)
    flash[:notice] = "Message deleted."
    redirect_to emails_path
  end

  def reply
    message = mailbox.fetch_message(uid)
    @email = process_message(message, "Re: #{message.subject}", <<PREPEND, message.from)
<br />
<br />
<hr />
<p>On #{message.date}, #{message.from} wrote:</p>
PREPEND
    render :action => 'new'
  end

  def forward
    message = mailbox.fetch_message(uid)
    @email = process_message(message, "Fwd: #{message.subject}", <<PREPEND)
<br />
<br />
<hr />
<p>
  Original Message:<br />
  Date: #{message.date}<br />
  From: #{message.from}<br />
  To: #{message.to}<br />
  Subject #{message.subject}
</p>
PREPEND
    render :action => 'new'
  end

  def select_mailbox
    mb = params[:mb]
    @mailbox = imap.select mb
    session['mailbox'] = mb
  rescue
    flash[:error] = "Failed to select mailbox #{mb}"
  ensure
    redirect_to emails_path
  end

  def mass_process
    case params["commit"]
    when "Delete"
      mailbox.delete_messages(params["uid"].keys)
      flash[:notice] = "Messages deleted."
    end
    redirect_to emails_path
  end

  def add_attachment
    session['attachment_count'] += 1
    render :partial => 'attachment', :layout => false
  end

  def header
    @header = mailbox.fetch_message(uid).header
  end

  def whitelist_uid
    current_user.uid_image_whitelists.find_or_create_by_uid uid
    redirect_to email_path(uid)
  end

  private
    #TODO: fix this hack
    def uid
      @uid ||= (params[:uid] || params[:id]).to_i
    end

    def helper
      @helper ||= Helper.new self
    end

    def set_charset(charset)
      headers['Content-Type'] = "text/html; charset=#{charset}"
    end

    def process_message(message, subject, prepend = '', to = nil)
      if message.html.nil?
        body = message.plain
        type = :plain
      else
        body = message.html
        type = :html
      end
      email = Email.new(current_user, helper, :body => body, :subject => subject, :to => to, :uid => uid, :message_type => type)
      email.prepend = prepend
      email
    end
end
