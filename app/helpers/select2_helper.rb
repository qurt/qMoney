module Select2Helper
    def init(model, field, attributes)
        id = "#{model}_#{field}"
        name = "#{model}[#{field}]"

        select_tag = "<select id=\"#{id}\" name=\"#{name}\""
        unless attributes.nil?
            attributes.each do |key, v|
                select_tag += ' ' + key.to_s + '="' + v + '"'
            end
        end
        select_tag += '>'

        return select_tag
    end
    def select2(model, field, options_for_select, selected = nil, attributes = nil)
        select_tag = init(model, field, attributes)
        id = "#{model}_#{field}"

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
        select_tag = init(model, field, attributes)
        id = "#{model}_#{field}"

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

    def select2_grouped(model, field, collection, selected = nil, attributes = nil)
        select_tag = init(model, field, attributes)
        id = "#{model}_#{field}"

        options = ''
        collection.each do |key, data|
            options += "<optgroup label=\"#{key}\">"
            data.each do |title, value|
                if value == selected
                    options += "<option value=\"#{value}\" selected>#{title}</options>"
                else
                    options += "<option value=\"#{value}\">#{title}</options>"
                end
            end
            options += '</optgroup>'
        end

        select_tag += options
        select_tag += '</select>'
        script = "<script>$('##{id}').select2();</script>"

        result = select_tag + script
        return result.html_safe
    end
end
