# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

ready = ->
    type = $(this).val()
    if parseInt(type) == 2
        $('#account_limit_wrapper').show()
    else
        $('#account_limit_wrapper').hide()
    $('#account_account_type').change ->
        type = $(this).val()
        if parseInt(type) == 2
            $('#account_limit_wrapper').show()
        else
            $('#account_limit_wrapper').hide()

$(document).ready(ready)
$(document).on('page:load', ready)
