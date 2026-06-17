module RedmineMentions
  module JournalPatch
    def self.included(base)
      base.class_eval do
        after_create :send_mail
        
        def send_mail
          RequestStore.store[:redmine_mentions_notified] = false
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
                RequestStore.store[:redmine_mentions_notified] = true
              end
            end
          end
        end

      end
    end
  end
end

# Patch Journal notify to avoid double emails
module JournalNotifyPatch
  def send_notification
    unless RequestStore.store[:redmine_mentions_notified]
      super
    end
  end
end