require 'redmine'
Rails.configuration.to_prepare do
   require_dependency 'journal'
  Journal.send(:include, RedmineMentions::JournalPatch)
end
Redmine::Plugin.register :redmine_mentions do
  name 'Redmine Mentions'
  author 'Arkhitech'
  description 'This is a plugin for Redmine which gives suggestions on using username in comments'
  version '0.0.1'
  url 'http://example.com/path/to/plugin'
  author_url 'https://github.com/arkhitech/redmine_mentions'
  settings :default => {'trigger' => '@'}, :partial => 'settings/mention'
end
