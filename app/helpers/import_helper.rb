module ImportHelper
    def addRule

    end

    def importRowClass(status)
        case status
        when 0
            return 'danger'
        when 1
            return 'warning'
        when 2
            return 'success'
        end
    end
end
