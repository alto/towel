require File.dirname(__FILE__) + '/../spec_helper.rb'
require File.dirname(__FILE__) + '/../mailer_spec_helper.rb'

include MailerSpecHelper
include ActionMailer::Quoting

describe StatusMailer, "user_deleted" do
  before do
    setup_mail_test
    @user = mock_user
    @comment = 'unwürdig'
  end
  it "should send a mail" do
    @expected.subject = "[TOWEL] User deaktiviert!"
    @expected.body    = read_fixture('status_mailer/user_deleted.txt')
    @expected.from    = "noreply@tempodome.net"
    @expected.to      = @user.email

    mail = StatusMailer.create_user_deleted(@user, @comment).encoded
    mail.gsub!(/Date:.*\n/, '')
    mail.should == @expected.encoded
  end
end

describe StatusMailer, "user_undeleted" do
  before do
    setup_mail_test
    @user = mock_user
    @comment = 'wieder würdig'
  end
  it "should send a mail" do
    @expected.subject = "[TOWEL] User wieder aktiviert!"
    @expected.body    = read_fixture('status_mailer/user_undeleted.txt')
    @expected.from    = "noreply@tempodome.net"
    @expected.to      = @user.email

    mail = StatusMailer.create_user_undeleted(@user, @comment).encoded
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
