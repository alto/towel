require File.dirname(__FILE__) + '/../test_helper'
require File.dirname(__FILE__) + '/../mailer_test_helper'

class UserMailerTest < ActiveSupport::TestCase

  include MailerTestHelper
  include ActionMailer::Quoting

  context "signup notification" do
    setup do
      setup_mail_test
      @user = create_user
      @user.activation_code = 'abc'
    end
    should "send a mail" do
      @expected.subject = "[TOWEL] Bitte aktiviere Deinen Account!"
      @expected.body    = read_fixture('user_mailer/signup_notification.txt')
      @expected.from    = "noreply@tempodome.net"
      @expected.to      = @user.email

      mail = UserMailer.create_signup_notification(@user).encoded
      mail.gsub!(/Date:.*\n/, '')
      assert_equal @expected.encoded, mail
    end
  end

  context "activation" do
    setup do
      setup_mail_test
      @user = create_user
    end
    should "send a mail" do
      @expected.subject = "[TOWEL] Dein Account wurde aktiviert!"
      @expected.body    = read_fixture('user_mailer/activation.txt')
      @expected.from    = "noreply@tempodome.net"
      @expected.to      = @user.email

      mail = UserMailer.create_activation(@user).encoded
      mail.gsub!(/Date:.*\n/, '')
      assert_equal @expected.encoded, mail
    end
  end

  context "password_recover" do
    setup do
      setup_mail_test
      @user = create_user
      @user.activation_code = 'abc'
    end
    should "send a mail" do
      @expected.subject = "[TOWEL] Kennwort neu setzen"
      @expected.body    = read_fixture('user_mailer/password_recover.txt')
      @expected.from    = "noreply@tempodome.net"
      @expected.to      = @user.email

      mail = UserMailer.create_password_recover(@user).encoded
      mail.gsub!(/Date:.*\n/, '')
      assert_equal @expected.encoded, mail
    end
  end

  context "password_recovered" do
    setup do
      setup_mail_test
      @user = create_user
    end
    should "send a mail" do
      @expected.subject = "[TOWEL] Account reaktiviert"
      @expected.body    = read_fixture('user_mailer/password_recovered.txt')
      @expected.from    = "noreply@tempodome.net"
      @expected.to      = @user.email

      mail = UserMailer.create_password_recovered(@user).encoded
      mail.gsub!(/Date:.*\n/, '')
      assert_equal @expected.encoded, mail
    end
  end

  private
    def setup_mail_test
      @expected = TMail::Mail.new
      @expected.set_content_type 'text', 'plain', { 'charset' => MailerTestHelper::CHARSET }
      @expected.mime_version = '1.0'
    end

end
