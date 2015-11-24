# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

ready = ->
    button = $('#save_refresh')
    button.click ->
        save_refresh()

    category = $("#operation_category_id").parent().parent()
    transfer = $("#transfer_field")
    account_from = $('#operation_account_id')
    account_from_transfer = $('#operation-account-from')

    switch_visible = (val) ->
        switch val
            when '1'
                category.hide()
                transfer.hide()
                account_from.show()
                account_from_transfer.hide()
            when '2'
                category.hide()
                transfer.show()
                account_from.hide()
                account_from_transfer.show()
            else
                category.show()
                transfer.hide()
                account_from.show()
                account_from_transfer.hide()

    switch_visible($("#operation_type").val())

    $("#operation_type").change ->
        switch_visible($(this).val())

    $('[data-behaviour~=datepicker]').pickadate({
        format: "yyyy-mm-dd",
        formatSubmit: "yyyy-mm-dd"
    })


save_refresh = ->
    form = $("#new_operation")
    data = form.serialize()

    $.ajax({
        type: 'POST'
        url: form.attr('action')
        data: data
        success: () ->
            $('input[type=text]').val('')
    })


$(document).ready(ready)
$(document).on('page:load', ready)
