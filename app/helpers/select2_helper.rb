module Select2Helper
    def select2(id, model, options_for_select, selected = nil, attributes = nil)
        select_tag = '<select id="' + id + '" name="' + model + '"'
        unless attributes.nil?
            attributes.each do |name, value|
                select_tag += ' ' + name.to_s + '="' + value + '"'
            end
        end
        select_tag += '>'

        options = ''
        options_for_select.each do |key, value|
            if value == selected
                options += '<option value="'+value.to_s+'" selected>' + key.to_s + '</options>'
            else
                options += '<option value="'+value.to_s+'">' + key.to_s + '</options>'
            end
        end

        select_tag += options
        select_tag += '</select>'
        script = '<script>$("#' + id + '").select2();</script>'

        result = select_tag + script
        return result.html_safe
    end
end
