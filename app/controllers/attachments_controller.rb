class AttachmentsController < ApplicationController
  skip_before_filter  :verify_authenticity_token
  before_filter :require_user
  before_filter :restrict_to_images, :only => [:create]

  def show
    #attachment = Attachment.new(mailbox, params[:uid].to_i, :cid => params[:cid])
    attachments = mailbox.fetch_message(params[:uid].to_i).attachments
    case params[:disp]
    when 'inline'
      finder = lambda {|attachment| attachment.cid == URI.unescape(params[:cid])}
      disposition = 'inline'
    when 'attach'
      finder = lambda {|attachment| attachment.name == URI.unescape(params[:name])}
      disposition = 'attachment'
    end
    attachment = attachments.find { |a| finder.call(a) }
    #fucking '@'s in a Pathname sent to the Rack headers break Passenger for some godforsaken reason
    path = current_user.attachment_dir.join(attachment.name).to_s
    File.open(path, 'w') { |file| file.write(attachment.data) } unless File.exist?(path)
    x_send_file(path, :type => attachment.mime, :disposition => disposition)
  end

  def create
    @filename = URI.escape(current_user.upload(params[:image]), '.')
    render :layout => false
  end

  def show_uploaded
    name = File.basename(URI.unescape(params[:filename]))
    content_type = MIME::Types.type_for(name.sub(/_\d*?$/, '')).first || "application/octet-stream"
    path = current_user.attachment_dir.join(name).to_s
    x_send_file(path, :type => content_type, :disposition => 'inline')
  end

  private
    def restrict_to_images
      name = params[:image].original_filename rescue ""
      unless ['image/jpeg', 'image/gif', 'image/png'].include? MIME::Types.type_for(name).first
        render :text => "Please upload an image file (JPEG, GIF or PNG).", :status => 403
        return false
      end
    end

    def rescue_action_in_public
      render :text => "An error on the server has occurred and the administrators have been notified."
      return false
    end
end
