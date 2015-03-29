require 'redmine'

Rails.configuration.to_prepare do
  require_dependency 'redmine_mentions/hooks'
  require_dependency 'journal'
  Journal.send(:include, RedmineMentions::JournalPatch)
  Mailer.send(:include, RedmineMentions::MailerPatch)
end
Redmine::Plugin.register :redmine_mentions do
  name 'Redmine Mentions'
  author 'Arkhitech'
  description 'This is a plugin for Redmine which gives suggestions on using username in comments'
  version '0.0.1'
  url 'https://github.com/arkhitech/redmine_mentions'
  author_url 'http://www.arkhitech.com/'
  settings :default => {'trigger' => '@'}, :partial => 'settings/mention'
end
class SecondHelperIssuesHook < Redmine::Hook::ViewListener

  def helper_issues_show_detail_after_setting(context={})
    if context[:detail].prop_key == 'color'
      detail = context[:detail]
      detail.value = "no_color" if detail.value.nil? or detail.value.empty?
      detail.old_value = "no_color" if detail.old_value.nil? or detail.old_value.empty?

      context[:detail].value = l(("label_agile_color_" + detail.value.to_s).to_sym).downcase if detail.value
      context[:detail].old_value = l(("label_agile_color_" + detail.old_value.to_s).to_sym).downcase if detail.old_value
    end
  end

end
