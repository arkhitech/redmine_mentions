module RedmineMentions
	class Hooks < Redmine::Hook::ViewListener
		# This just renders the partial in
		# app/views/hooks/my_plugin/_view_issues_form_details_bottom.rhtml
		# The contents of the context hash is made available as local variables to the partial.
		#
		# Additional context fields
		#   :issue  => the issue this is edited
		#   :f      => the form object to create additional fields

		def view_issues_edit_notes_bottom(context={ })
			if ['textile', 'markdown'].include?(Setting.text_formatting)
				context[:controller].send(:render_to_string, {
					:partial => "hooks/redmine_mentions/edit_mentionable",
					:locals => context
				})
			end
		end

		def view_issues_form_details_bottom(context={ })
			if ['textile', 'markdown'].include?(Setting.text_formatting)
				context[:controller].send(:render_to_string, {
					:partial => "hooks/redmine_mentions/edit_mentionable",
					:locals => context
				})
			end
		end
	end
end
