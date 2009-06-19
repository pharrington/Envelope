require File.dirname(__FILE__) + '/spec_helper'

describe Attachable do
  before (:each) do
    o = Class.new do
      include Attachable
      alias :private_unique :unique
      alias :private_attachment_dir :attachment_dir
      alias :private_create_directory :create_directory
      alias :private_create_prefix :create_prefix

      def unique(fn); private_unique(fn); end
      def attachment_dir; private_attachment_dir; end
      def create_directory; private_create_directory; end
      def create_prefix; private_create_prefix; end
    end
    @o = o.new
  end

  it "creates the attachment directory beneath two two-digitable randomly named subdirectories" do
    @o.create_prefix.should match /^[0-9]{2}\/[0-9]{2}$/
  end

  it "prefixes the Rails root path to the stored directory, and appends the model's email attribute" do
    @o.stub!(:read_attribute).with(:attachment_dir).and_return('00/00')
    @o.should_receive(:email).and_return('email@test.com')
    Rails.should_receive(:root).and_return(Pathname.new('/test'))
    @o.attachment_dir.should == Pathname.new('/test/attachments/00/00/email@test.com')
  end

  it "returns nil for attachment_dir if the attachment_dir attribute is nil or blank" do
    @o.stub!(:read_attribute).with(:attachment_dir).and_return(nil, '')
    2.times { @o.attachment_dir.should be_nil }
  end

  it "appends given filename with an ascending integer if the filename already exists" do
    fn = "file"
    File.should_receive(:exists?).and_return(true, false)
    @o.unique(fn).should == "#{fn}_1"
  end

  it "uses the supplied filename if it does not exist" do
    fn = "file"
    File.should_receive(:exists?).and_return(false)
    @o.unique(fn).should == fn
  end

  #it "creates a new upload directory for the user and saves it to the DB if the model's attachment_dir attribute is null or blank" do
    #@o.should_receive(:read_attribute).with(:attachment_dir).and_return(nil)
    #@o.should_receive(:create_prefix)
    #Dir.should_receive(:mkdir)
    #@o.should_receive(:save)
    #@o.create_directory.should == true
  #end

  it "shouldn't create a new directory prefix or save to the DB if the model has the attachment_dir attribute and the directory exists" do
    @o.should_receive(:read_attribute).with(:attachment_dir).and_return('00/00')
    @o.should_receive(:email).and_return('email@test.com')
    Dir.should_receive(:mkdir).and_raise(Errno::EEXIST)
    @o.should_not_receive(:create_prefix)
    @o.create_directory.should == false
  end

  #it "saves an uploaded file to a unique name in the user's attachment directory, returning the new filename" do
    #fn = 'file'
    #attachment = mock("UploadedTempFile")
    #@o.should_receive(:create_directory)
    #attachment.should_receive(:original_filename).and_return(fn)
    #File.should_receive(:exists?).and_return(true)
    #FileUtils.should_receive(:mv)
    #@o.upload(attachment).should == "#{fn}_1"
  #end
end
