require File.dirname(__FILE__) + '/../test_helper'
require File.dirname(__FILE__) + '/../mailer_test_helper'

class SystemMailerTest < ActiveSupport::TestCase

  include MailerTestHelper
  include ActionMailer::Quoting

  context "contact" do
    setup do
      setup_mail_test
      @name     = 'test name'
      @email    = 'test@test.com'
      @subject  = 'test subject'
      @body     = 'test body'
    end
    should "send a mail" do
      @expected.subject = "[CONTACT] #{@subject}"
      @expected.body    = read_fixture('system_mailer/contact.txt')
      @expected.from    = @email
      @expected.to      = "noreply@tempodome.net"

      mail = SystemMailer.create_contact(@name, @email, @subject, @body).encoded
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
