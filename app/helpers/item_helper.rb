module ItemHelper
	def keyword_html(item)
		return "Keyword: <span class=\"spanKeyword\">#{item.keyword.value}</span>\n"
	end

	def task_list_html(item)
		html = "<li>#{link_to("Map", item.map_url)}</li>\n"
		if !item.new_record? && !item.keyword.nil?
			html << "<li><strong><a href="
			html << url_for(:action => 'print_banner', :id => item.id)
			html << ">Print Banner</a></strong></li>\n"
		end
		return html
	end

	def create_item_button(id)
		html = submit_to_remote( 'submit', 'Create Keyword', 
														:id => "submit_#{id}",
														:url => { :action => "create", :id => id }, 
														:loading => "$('progress_#{id}').show();$('submit_#{id}').hide();", 
													 	:complete => "$('progress_#{id}').hide();")
		html << "<span id=\"progress_#{id}\" style=\"display: none\"><img src=\"/images/indicator_arrows.gif\"></span>"
		return html
	end
end
