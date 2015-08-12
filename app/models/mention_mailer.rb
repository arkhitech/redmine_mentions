class MentionMailer < ActionMailer::Base
  layout 'mailer'
  default from: Setting.mail_from
  def self.default_url_options
    Mailer.default_url_options
  end
  
  
  def notify_mentioning(issue, mentioned_by, mentioned_text, mentioned_user)
    @issue = issue
    @mentioned_by = mentioned_by
    @mentioned_text = mentioned_text
    mail(to: mentioned_user.mail, subject: "[#{@issue.tracker.name} ##{@issue.id}] #{@mentioned_by} mentioned you in the issue: #{@issue.subject}")
  end
end