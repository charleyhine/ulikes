# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
	def ajax_window_link(name, title, url, options = {})
		if !options.nil? && !options["width"].nil? && !options["height"].nil? 
			height = options["height"]
			widht = options["width"]
			link_to_function(name, "ajaxWindow('#{title}', '#{url}', #{width}, #{height});")
		else
			link_to_function(name, "ajaxWindow('#{title}', '#{url}', 540, 400);")
		end
	end

	def editable_content(object, method, id, content, options = {})
		content = 'Click to edit...' if content == ''
		url = url_for({ :action => "set_#{object}_#{method}", :id => id })
		ajax_options = { :okText => "'Save'", :cancelText => "'Cancel'"}.merge(options || {})
		tag_options = { :id => "#{object}_#{method}_#{id}_in_place_editor", :class => "in_place_editor_field"}
		script = Array.new
		script << "new Ajax.InPlaceEditor("
		script << "  '#{tag_options[:id]}',"
		script << "  '#{url_for(url)}',"
		script << "  {"
		script << ajax_options.map{ |key, value| "#{key.to_s}: #{value}" }.join(", ")
		script << "  }"
		script << ")"

		content_tag(
			'span',
			content,
			tag_options	
		) + javascript_tag( script.join("\n") )
	end

	def get_recently_popular
		return Item.find_recent_items
	end

	def get_recent_votes
		return Item.find_recently_voted
	end

	def get_top_ten
		return Item.find_top_ten
	end

	def progress_spinner_js(element_name)
		return "$('#{element_name}').update('<img src=\"/images/indicator_arrows.gif\"');"
	end

  def item_hidden_fields(item)
			html = "<input type=\"hidden\" name=\"item[type]\" value=\"PlaceItem\">"
      html << "<input type=\"hidden\" name=\"item[name]\" value=\"#{item.name}\">"
      html << "<input type=\"hidden\" name=\"item[street]\" value=\"#{item.street}\">"
      html << "<input type=\"hidden\" name=\"item[city_id]\" value=\"#{item.city.id}\">"
      html << "<input type=\"hidden\" name=\"item[state_id]\" value=\"#{item.state.id}\">"
      html << "<input type=\"hidden\" name=\"item[phone_number]\" value=\"#{item.phone_number}\">"
      html << "<input type=\"hidden\" name=\"item[latitude]\" value=\"#{item.latitude}\">"
      html << "<input type=\"hidden\" name=\"item[longitude]\" value=\"#{item.longitude}\">"
      html << "<input type=\"hidden\" name=\"item[yahoo_local_id]\" value=\"#{item.yahoo_local_id}\">"
      return html
  end
end
