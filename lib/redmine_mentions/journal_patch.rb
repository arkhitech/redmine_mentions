module RedmineMentions
  module JournalPatch
    def self.included(base)
      base.class_eval do
        after_create :send_mail

        def send_mail
          if self.journalized.is_a?(Issue) && self.notes.present?
            issue = self.journalized
            project=self.journalized.project
            users=project.users.to_a.delete_if{|u| (u.type != 'User' || u.mail.empty?)}
            users_regex=users.collect{|u| "#{Setting.plugin_redmine_mentions['trigger']}#{u.login}"}.join('|')
            regex_for_email = '\B('+users_regex+')\b'
            regex = Regexp.new(regex_for_email)

            mentioned_users = self.notes.scan(regex)
            mentioned_users.each do |mentioned_user|
              username = mentioned_user.first[1..-1]
              if user = User.find_by_login(username)
                MentionMailer.notify_mentioning(issue, self, user).deliver
              end
            end

            all_mentions = self.notes.scan(Regexp.new("(#{Setting.plugin_redmine_mentions['trigger']}\\w+)"))
            not_notified = all_mentions - mentioned_users

            if !flash[:notice].blank? && not_notified.any?
              flash[:notice] += content_tag(:p, l(:label_issue_notice_recipients) + not_notified.join('; '), :class => 'email-was-not-sent')
              flash[:notice] = flash[:notice].html_safe
            end
          end
        end
      end
    end
  end
end
