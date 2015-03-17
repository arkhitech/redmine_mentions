module RedmineMentions
  module MailerPatch
    def self.included(base)
      base.class_eval do

        def notify_mentioning(issue, journal, user)
          @issue = issue
          @journal = journal
          subject = "[#{issue.project.to_s} - #{issue.tracker.name} ##{issue.id}] (#{issue.status.name}) #{issue.subject}"
          mail(to: user.mail, subject: subject)
        end

      end
    end
  end
end