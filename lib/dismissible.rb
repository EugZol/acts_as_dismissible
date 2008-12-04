module Dismissible
  module Controller  
    def self.included(base)
      base.send :helper_method, :cookies
    end
  end
  
  module Helpers
    def dismissible_message(opts={}, &block)
      id = params[:controller] + '/' + params[:action]
      opts.reverse_merge!({ :message => "Закрыть", :class => "helper", :follows => nil, :style => "" })
      
      return if session[id]
      
      unless HelperMessage.show?(id, current_user)
        session[id] = true
        return
      end

      id = "help_message_#{id}"
      
      concat(content_tag(:div,
        %{<p>#{link_to_dismiss(id,opts)}</p>} + capture(&block), 
        :class => opts[:class], :style => opts[:style], :id => id), 
        block.binding)
    end
    
    def link_to_dismiss(id, opts)
      link_to_function(opts[:message], dismissal_javascript_for(id), { :class => "close" })
    end
    
    def dismissal_javascript_for(id)
      "new Ajax.Request('#{mark_helper_message_path + '/' + params[:controller] + '/' + params[:action]}',
        {method: 'post', parameters: {_method: 'delete'}}); return $('#{id}').remove() && false"
    end
  end
end