require 'roadie'

class MentionMailer < ActionMailer::Base
  layout 'mailer'
  helper :application

  include Redmine::I18n
  include Roadie::Rails::Automatic

  default from: Setting.mail_from
  def self.default_url_options
    Mailer.default_url_options
  end
 
  def notify_mentioning(issue, journal, user)
    @issue = issue
    @journal = journal
    @textnote = ActionView::Base.full_sanitizer.sanitize(journal.notes)
    mail(to: user.mail, subject: "[#{@issue.tracker.name} ##{@issue.id}] #{l(:mentioned_in)}: #{@issue.subject}")
  end
end
