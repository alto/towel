require File.dirname(__FILE__) + '/../spec_helper.rb'
require File.dirname(__FILE__) + '/../mailer_spec_helper.rb'

include MailerSpecHelper
include ActionMailer::Quoting

describe SystemMailer, "contact" do
  before do
    setup_mail_test
    @name     = 'test name'
    @email    = 'test@test.com'
    @subject  = 'test subject'
    @body     = 'test body'
  end
  it "should send a mail" do
    @expected.subject = "[CONTACT] #{@subject}"
    @expected.body    = read_fixture('system_mailer/contact.txt')
    @expected.from    = @email
    @expected.to      = "noreply@tempodome.net"

    mail = SystemMailer.create_contact(@name, @email, @subject, @body).encoded
    mail.gsub!(/Date:.*\n/, '')
    mail.should == @expected.encoded
  end
end

private
  def setup_mail_test
    @expected = TMail::Mail.new
    @expected.set_content_type 'text', 'plain', { 'charset' => MailerSpecHelper::CHARSET }
    @expected.mime_version = '1.0'
  end
