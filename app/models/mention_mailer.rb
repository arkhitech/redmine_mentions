class MentionMailer < ActionMailer::Base
  layout 'mailer'
  default from: Setting.mail_from

  helper :application
  include ApplicationHelper

  def self.default_url_options
   h = Setting.host_name
   h = h.to_s.gsub(%r{\/.*$}, '') unless Redmine::Utils.relative_url_root.blank?
   { :host => h, :protocol => Setting.protocol }
  end


  def notify_mentioning(issue, journal, user)
    @issue = issue
    @journal = journal
    mail(to: user.mail, subject: "[#{@issue.tracker.name} ##{@issue.id}] You were mentioned in: #{@issue.subject}")
  end
end
