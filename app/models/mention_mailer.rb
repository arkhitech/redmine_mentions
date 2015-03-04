class MentionMailer < ActionMailer::Base
  include Redmine::I18n

  helper_method :format_time

  layout 'mailer'
  default from: Setting.mail_from
  def self.default_url_options
    Mailer.default_url_options
  end
  
  
  def notify_mentioning(issue, journal, user)
    @issue = issue
    @journal = journal
    subject = "[#{issue.project.to_s} - #{issue.tracker.name} ##{issue.id}] (#{issue.status.name}) #{issue.subject}"
    mail(to: user.mail, subject: subject)
  end
end
