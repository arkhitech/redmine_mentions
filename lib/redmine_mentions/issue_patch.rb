module RedmineMentions
  module IssuePatch
    def self.included(base)
      base.class_eval do
        after_create :send_mail
        
        def send_mail
          issue = self
          project=self.project
          users=project.users.to_a.delete_if{|u| (u.type != 'User' || u.mail.empty?)}
          users_regex=users.collect{|u| "#{Setting.plugin_redmine_mentions['trigger']}#{u.login}"}.join('|')
          regex_for_email = '\B('+users_regex+')'
          regex = Regexp.new(regex_for_email)
          mentioned_users = self.description.scan(regex)
          usernames = []
          mentioned_users.each do |mentioned_user|
            usernames << mentioned_user.first[1..-1]
          end
          users = User.where(login: usernames)
          users.each do |user|
            MentionMailer.notify_mentioning(issue, issue.author.login, issue.description, user).deliver
          end
        end
      end
    end
  end
end