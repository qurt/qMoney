module Select2Helper
    def select2(id, model, options_for_select, selected = nil, attributes = nil)
        select_tag = "<select id=\"#{id}\" name=\"#{model}\""
        unless attributes.nil?
            attributes.each do |name, value|
                select_tag += " #{name}=\"#{value}\""
            end
        end
        select_tag += '>'

        options = ''
        options_for_select.each do |key, value|
            if value == selected
                options += "<option value=\"#{value}\" selected>#{key}</options>"
            else
                options += "<option value=\"#{value}\">#{key}</options>"
            end
        end

        select_tag += options
        select_tag += '</select>'
        script = "<script>$('##{id}').select2();</script>"

        result = select_tag + script
        return result.html_safe
    end

    def select2_collection(model, field, collection, value, title, selected = nil, attributes = nil)
        id = "#{model}_#{field}"
        name = "#{model}[#{field}]"

        select_tag = "<select id=\"#{id}\" name=\"#{name}\""
        unless attributes.nil?
            attributes.each do |name, value|
                select_tag += ' ' + name.to_s + '="' + value + '"'
            end
        end
        select_tag += '>'

        options  = ''
        collection.each do |item|
            option_value = item[value]
            option_title = item[title]
            if value == selected
                options += "<option value=\"#{option_value}\" selected>#{option_title}</option>"
            else
                options += "<option value=\"#{option_value}\">#{option_title}</option>"
            end
        end

        select_tag += options
        select_tag += '</select>'
        script = "<script>$('##{id}').select2();</script>"

        result = select_tag + script
        return result.html_safe
    end

    def select2_grouped

    end
end
