class MentionMailer < ActionMailer::Base
  layout 'mailer'
  default from: Setting.mail_from
  def self.default_url_options
    Mailer.default_url_options
  end
  
  
  def notify_mentioning(issue, journal, user)
    @issue = issue
    @journal = journal
    mail(to: user.mail, subject: "You were mentioned in a note").deliver
  end
end