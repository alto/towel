class StatusMailer < ActionMailer::Base

  def user_deleted(user, comment)
    setup_email(user)
    @subject       += 'User deaktiviert!'
    @body[:user]    = user
    @body[:comment] = comment
  end
  def user_undeleted(user, comment)
    setup_email(user)
    @subject       += 'User wieder aktiviert!'
    @body[:user]    = user
    @body[:comment] = comment
  end
  
  protected
    def setup_email(recipient)
      @recipients  = "#{recipient.email}"
      @from        = "noreply@tempodome.net"
      @subject     = "[TOWEL] "
      @sent_on     = Time.now
    end
end
