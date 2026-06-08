require 'redmine'

def load_redmine_mentions_patches
  require_relative 'lib/redmine_mentions/hooks'
  Journal.send(:include, RedmineMentions::JournalPatch)
end

load_redmine_mentions_patches

Rails.configuration.to_prepare do
  load_redmine_mentions_patches
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