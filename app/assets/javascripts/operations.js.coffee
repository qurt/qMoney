# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
ready = ->
    category = $("#operation_category_id").parent().parent()
    transfer = $("#transfer_field")

    if $("#operation_type").val() is '1'
        category.hide()

    if $("#operation_type").val() is '2'
        transfer.show()
        category.hide()

    $("#operation_type").change ->
        switch $(this).val()
            when '1'
                category.hide()
                transfer.hide()
            when '2'
                category.hide()
                transfer.show()
            else
                category.show()
                transfer.hide()

    $('[data-behaviour~=datepicker]').pickadate({
        format: "yyyy-mm-dd",
        formatSubmit: "yyyy-mm-dd"
    })

$(document).ready(ready)
$(document).on('page:load', ready)
