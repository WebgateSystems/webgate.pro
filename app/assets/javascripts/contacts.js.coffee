# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).ready ->
  $("#new_contact")
    .on "ajax:success", (event, data, status, xhr) ->
      $.getScript(document.location.href = "/contact_complete")
    .on "ajax:error", (event, data, status, xhr) ->
      $.each($.parseJSON(data.responseText), (field, messages) ->
        #console.log(field)
        #console.log(messages)
        input = $("new_contact").find(':input').filter( ->
          name = $(this).attr('email')
          if name
            name.match(new RegExp('contact' + '\\[' + field + '\\(?'))
        )
        input.parent().css('border','1px solid red')
        input.closest('.form-group').addClass('has-error')
        console.log(input)
        input.parent().append('<span class="help-block">' + $.map(messages, (m) -> m.charAt(0).toUpperCase() + m.slice(1)).join('<br />') + '</span>')
      )
