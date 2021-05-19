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
            users_regex=users.collect{|u| "\"#{Regexp.escape("#{u.firstname} #{u.lastname}")}\":#{Setting.protocol}://#{Setting.host_name}#{Rails.application.routes.url_helpers.user_path(u)}".gsub(/(["\/])/, '\\\\\1')}.join('|')
            regex_for_email = '\B('+users_regex+')\b'
            regex = Regexp.new(regex_for_email)
            mentioned_users = self.notes.scan(regex).uniq
            mentioned_users.each do |mentioned_user|
              username = mentioned_user.first[1..-1].split("/").last
              if user = User.find_by_id(username)
                MentionMailer.notify_mentioning(issue, self, user).deliver
              end
            end
          end
        end
      end
    end
  end
end
