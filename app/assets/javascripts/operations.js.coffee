# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$(document).ready ->
  category = $("#operation_category_id").parent().parent()
  $("#operation_type").change ->
    if $(this).val() is '1'
      category.hide()
    else
      category.show()
    return

  return
