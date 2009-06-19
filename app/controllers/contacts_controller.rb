class ContactsController < ApplicationController
  before_filter :require_user

  def index
    @contacts = current_user.contacts.paginate :page => current_page
  end

  def new
    @contact = Contacts::Contact.new
  end

  def create
    @contact = Contacts::Contact.new(params["contacts_contact"])
    current_user.contacts << @contact
    if @contact
      flash[:notice] = "#{@contact.name} has been added"
      redirect_to contact_path(@contact)
    else
      render :action => new
    end
  end

  def show
    @contact = current_user.contacts.find params[:id]
  end

  def edit
    @contact = current_user.contacts.find params[:id]
  end

  def update
    @contact = current_user.contacts.find params[:id]
    if @contact.update_attributes params["contacts_contact"]
      flash[:notice] = "#{@contact.name} has been updated"
      redirect_to contact_path(@contact)
    else
      render :action => :edit
    end
  end

  def destroy
    @contact = current_user.contacts.find params[:id]
    if @contact.destroy
      flash[:notice] = "#{@contact.name} has been deleted"
    end
    redirect_to contacts_path
  end

  def add_item
    item = params[:item]
    unless %w[Email Phone Address IM].include? item
      render :text => "An error on the server has occurred and the administrators have been notified.", :status => 403
      return false
    end
    render :partial => item.downcase, :object => "Contacts::#{item}".constantize.new
  end

  private
    def current_page
      @page = params[:page] || 1
    end
end
