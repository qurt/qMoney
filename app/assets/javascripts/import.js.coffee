# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

ready = () ->
    $('.open-modal').click () ->
        id = $(this).data('id')
        window.item = window.list[id]

        if window.item
            $('#account_placeholder').html(window.item.account)
            $('#type_placeholder').html(if window.item.operation.type == 0 then 'Расход' else 'Доход')
            $('#category_placeholder').html(window.item.category)

    $('#save_rule_button').click () ->
        unless window.item
            return true

        post_data = {
            data: window.item
        }
        form = $('#modal-window').find('form')
        post_data.data.operation.account_id = form.find('#rule_account_id').val()
        post_data.data.operation.category_id = form.find('#rule_category_id').val()
        $.ajax({
            type: 'POST'
            url: '/import/new_rule'
            data: post_data
            success: (res) ->
                window.item.status = 2
                check_all_row(post_data.data.category, post_data.data.account)
                $('#modal-window').modal('hide')
        })

    check_all_row = (import_category, import_account) ->
        $('table').find('tr').each (index) ->
            check = 0
            $(this).find('td').each (cell) ->
                if $(this).text() == import_account or $(this).text() == import_category
                    check += 1
                    $(this).parent().removeClass('danger success').addClass('warning') if check == 1
                    $(this).parent().removeClass('danger warning').addClass('success') if check == 2
                    window.list[index-1].status = check if window.list[index-1]




$(document).ready(ready)
$(document).on('page:load', ready)
