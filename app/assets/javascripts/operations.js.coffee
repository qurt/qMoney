# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
ready = ->
  category = $("#operation_category_id").parent().parent()

  if $("#operation_type").val() is '1'
    category.hide()

  $("#operation_type").change ->
    if $(this).val() is '1'
      category.hide()
    else
      category.show()
    return

  $('[data-behaviour~=datepicker]').pickadate({
    format: "yyyy-mm-dd",
    formatSubmit: "yyyy-mm-dd"
  })

$(document).ready(ready)
$(document).on('page:load', ready)
