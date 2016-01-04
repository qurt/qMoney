module MorrisHelper
    def donut_chart(element, list)
        data = []
        colors = []
        list.each do |elem|
            item = elem[1]
            data << {
                label: item[:title],
                value: item[:value].round(2)
            }
            colors << item[:color]
        end

        options = {
            element: element,
            data: data,
            colors: colors,
            resize: true
        }

        result = '<div id="' + element + '"></div>'
        result += '<script>Morris.Donut(' + options.to_json + ');</script>'

        return result.html_safe
    end
end
