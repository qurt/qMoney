# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
ready = ->
  $('[data-behaviour~=datepicker_range]').datepicker({
    format: "dd.mm.yyyy",
    weekStart: 1,
    todayBtn: "linked",
    language: "ru",
    autoclose: true,
    todayHighlight: true
  })

$(document).ready(ready)
$(document).on('page:load', ready)