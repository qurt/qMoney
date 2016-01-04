# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

ready = ->
    $("tr[data-link]").click((event) ->
        event.preventDefault()
        window.location = $(this).data("link")
    )


$(document).ready(ready)
$(document).on('page:load', ready)
