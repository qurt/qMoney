module ChartistHelper
    def donut_chart(element, list)
        # data = {
        #     labels: ['test1', 'test2'],
        #     series: [10, 23]
        # }
        # data = {
        #     labels: [],
        #     series: []
        # }
        # list.each do |item|
        #     data[:labels].push item[1][:title]
        #     data[:series].push item[1][:value]
        # end
        # options = {
        #     donut: true,
        #     donutWidth: 60,
        #     chartPadding: 30,
        #     labelOffset: 50,
        #     labelDirection: 'explode'
        # }

        data = []
        list.each do |elem|
            item = elem[1]
            data << {
                label: item[:title],
                value: item[:value].round(2)
            }
        end

        options = {
            element: element,
            data: data,
            resize: true
        }

        result = '<div id="' + element + '"></div>'
        # result += '<script>new Chartist.Pie(".' + element + '", ' + data.to_json + ', ' + options.to_json + ');</script>'
        result += '<script>Morris.Donut(' + options.to_json + ');</script>'

        return result.html_safe
    end
end
