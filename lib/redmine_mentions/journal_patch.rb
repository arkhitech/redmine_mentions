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
            regex_for_email = '\B('+users_regex+')'
            regex = Regexp.new(regex_for_email)
            
            mentioned_users = self.notes.scan(regex)
            usernames = []
            mentioned_users.each do |mentioned_user|
              usernames << mentioned_user.first[1..-1]
            end
            users = User.where(login: usernames)
            users.each do |user|
              MentionMailer.notify_mentioning(issue, self.user.login, self.notes, user).deliver
            end
          end
        end
      end
    end
  end
end
