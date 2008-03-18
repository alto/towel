require File.dirname(__FILE__) + '/../spec_helper.rb'
require File.dirname(__FILE__) + '/../mailer_spec_helper.rb'

include MailerSpecHelper
include ActionMailer::Quoting

describe UserMailer, "signup notification" do
  before do
    setup_mail_test
    @user = mock_user(:activation_code => 'abc')
  end
  it "should send a mail" do
    @expected.subject = "[INLIGHT] Bitte aktiviere Deinen Account!"
    @expected.body    = read_fixture('user_mailer/signup_notification.txt')
    @expected.from    = "noreply@tempodome.net"
    @expected.to      = @user.email

    mail = UserMailer.create_signup_notification(@user).encoded
    mail.gsub!(/Date:.*\n/, '')
    mail.should == @expected.encoded
  end
end

describe UserMailer, "activation" do
  before do
    setup_mail_test
    @user = mock_user
  end
  it "should send a mail" do
    @expected.subject = "[INLIGHT] Dein Account wurde aktiviert!"
    @expected.body    = read_fixture('user_mailer/activation.txt')
    @expected.from    = "noreply@tempodome.net"
    @expected.to      = @user.email

    mail = UserMailer.create_activation(@user).encoded
    mail.gsub!(/Date:.*\n/, '')
    mail.should == @expected.encoded
  end
end

describe UserMailer, "password_recover" do
  before do
    setup_mail_test
    @user = mock_user(:activation_code => 'abc')
  end
  it "should send a mail" do
    @expected.subject = "[INLIGHT] Kennwort neu setzen"
    @expected.body    = read_fixture('user_mailer/password_recover.txt')
    @expected.from    = "noreply@tempodome.net"
    @expected.to      = @user.email

    mail = UserMailer.create_password_recover(@user).encoded
    mail.gsub!(/Date:.*\n/, '')
    mail.should == @expected.encoded
  end
end

describe UserMailer, "password_recovered" do
  before do
    setup_mail_test
    @user = mock_user
  end
  it "should send a mail" do
    @expected.subject = "[INLIGHT] Account reaktiviert"
    @expected.body    = read_fixture('user_mailer/password_recovered.txt')
    @expected.from    = "noreply@tempodome.net"
    @expected.to      = @user.email

    mail = UserMailer.create_password_recovered(@user).encoded
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
