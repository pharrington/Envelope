class Email
  include MassAssignable

  attr_accessible :to, :subject, :body, :attachments, :charset, :uid, :message_type
  attr_accessor :from, :prepend

  def initialize(current_user=nil, helper = nil, params = {})
    if current_user
      @user = current_user
      @from = PMail::Address.new(current_user.email, current_user.display_name)
      @attachment_path = current_user.attachment_dir
    end
    @helper = helper
    @attachments = nil
    @blocked_images = false
    super(params)
  end

  def deliver(user, pass)
    message = PMail::SMTP::Message.new(
      @from,
      @to,
      @subject,
      @charset || "UTF-8",
      plain,
      html,
      @attachments
    )
    smtp = PMail::SMTP.new(:host => 'badenoughdu.de', :user => user, :pass => pass, :auth => :login)
    smtp.send_message(message)
  end

  def attachments=(hash)
    unless hash.nil? || hash.empty?
      hash.each_value do |attachment|
        name = @user.upload(attachment)
        attach!(PMail::SMTP::Attachment.new(name, nil, read_attachment(name)))
      end
    end
  end

  def new_record? #to cooperate with Rails form helpers and such
    true
  end

  def body
    text = case @message_type
    when :html
      clean_html(@body)
    when :plain
      @helper.clean_plain(@body)
    else
      @body
    end
    (prepend || '') + text
  end

  def mailbox=(mailbox)
    @mailbox = mailbox
  end

  def blocked_images?
    @blocked_images
  end

  private
    def read_attachment(name)
      File.read(@attachment_path.join(name))
    end

    def plain
      @helper.clean_plain(Sanitize.clean(@body))
    end

    def attach!(attachment)
      (@attachments ||= []) << attachment
    end

    def external_images?(text)
       doc = Hpricot(text)
       (doc/"//img").each { |img| return true unless img["src"] && img["src"] =~ %r!^(?:\.\.)?(?:/|http://mce_host|cid:|$)! }
       false
    end

    def clean_html(text)
      if external_images? text
        @blocked_images = @user.uid_image_whitelists.find(@uid).nil? rescue true
      end
      @helper.clean_html(text, @uid, @blocked_images)
    end

    def html
      doc = Hpricot(clean_html(@body))
      attachments = nil
      (doc/"//img").each do |img|
        next if img["src"].nil?
        cid_part = "[a-zA-Z0-9@._:\\- ]+"
        case URI.unescape(URI.unescape(img["src"]))
        when %r[^(?:http://mce_host)?#{URI.unescape(@helper.inline_attachments_path("([0-9]+)", "(#{cid_part})"))}] #received inline attachment
          cid = File.basename($2)
          attachments ||= @mailbox.fetch_message($1).attachments
          name = attachments.find { |a| a.cid == cid }.name
          attach!(PMail::SMTP::Attachment.new(name, cid, read_attachment(name)))
          img["src"] = "cid:#{cid}"
        when %r[(?:\.\./)*/*uploaded_content/(#{cid_part})] #uploaded inline attachment
          attach!(PMail::SMTP::Attachment.new($1, $1, read_attachment($1)))
          img["src"] = "cid:#$1"
        end
      end
      doc.to_html
    end
end
