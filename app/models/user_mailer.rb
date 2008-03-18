class UserMailer < ActionMailer::Base
  def signup_notification(user)
    setup_email(user)
    @subject    += 'Bitte aktiviere Deinen Account!'
  end
  
  def activation(user)
    setup_email(user)
    @subject    += 'Dein Account wurde aktiviert!'
  end
  
  def password_recover(user)
    setup_email(user)
    @subject    += 'Kennwort neu setzen'
  end

  def password_recovered(user)
    setup_email(user)
    @subject    += 'Account reaktiviert'
  end

  protected
    def setup_email(user)
      @recipients  = "#{user.email}"
      @from        = "noreply@tempodome.net"
      @subject     = "[INLIGHT] "
      @sent_on     = Time.now
      @body[:user] = user
    end
end
