class SystemMailer < ActionMailer::Base

  def contact(name, email, subject, body)
    setup_email(email)
    @subject = "[CONTACT] #{subject}"
    @body[:name] = name
    @body[:body] = body
  end
  
  protected
    def setup_email(sender, recipients="noreply@tempodome.net")
      @recipients  = recipients
      @from        = sender
      @sent_on     = Time.now
    end
end

