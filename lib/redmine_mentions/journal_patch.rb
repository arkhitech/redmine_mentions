module RedmineMentions
  module JournalPatch
    def self.included(base)
      base.class_eval do
        after_create :send_mail
        
        def send_mail
          if self.journalized.is_a?(Issue) && self.notes.present?
            issue = self.journalized
            # TODO Should ignore email
            string = "\\#{Setting.plugin_redmine_mentions['trigger']}\\w+"
            regex = Regexp.new(string)
            mentioned_users = self.notes.scan(regex)
            mentioned_users.each do |mentioned_user|
              username = mentioned_user[1..-1] # Remove the heading '@'
              if user = User.find_by_login(username)
                MentionMailer.notify_mentioning(issue, self, user)
              end
            end
          end
        end
      end
    end
  end
end