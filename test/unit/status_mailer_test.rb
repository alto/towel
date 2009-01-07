require File.dirname(__FILE__) + '/../test_helper'
require File.dirname(__FILE__) + '/../mailer_test_helper'

class StatusMailerTest < ActiveSupport::TestCase

  include MailerTestHelper
  include ActionMailer::Quoting
  
  context "user_deleted" do
    setup do
      setup_mail_test
      @user = create_user
      @comment = 'unwürdig'
    end
    should "send a mail" do
      @expected.subject = "[TOWEL] User deaktiviert!"
      @expected.body    = read_fixture('status_mailer/user_deleted.txt')
      @expected.from    = "noreply@tempodome.net"
      @expected.to      = @user.email

      mail = StatusMailer.create_user_deleted(@user, @comment).encoded
      mail.gsub!(/Date:.*\n/, '')
      assert_equal @expected.encoded, mail
    end
  end

  context "user_undeleted" do
    setup do
      setup_mail_test
      @user = create_user
      @comment = 'wieder würdig'
    end
    should "send a mail" do
      @expected.subject = "[TOWEL] User wieder aktiviert!"
      @expected.body    = read_fixture('status_mailer/user_undeleted.txt')
      @expected.from    = "noreply@tempodome.net"
      @expected.to      = @user.email

      mail = StatusMailer.create_user_undeleted(@user, @comment).encoded
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
