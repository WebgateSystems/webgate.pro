# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).ready ->
  $("#new_contact")
    .on "ajax:success", (event, data, status, xhr) ->
      $("#form_msg").css('opacity', '1.0')
      $("#form_msg").show().delay(1000)
      $('#form_msg').animate
        opacity: 0
      , 3000
      , ->
        $(this).hide()
      $("#new_contact")[0].reset()
    .on "ajax:error", (event, data, status, xhr) ->
      $.each($.parseJSON(data.responseText), (field, messages) ->
        input = $("#new_contact").find(':input').filter( ->
          name = $(this).attr('name')
          if name
            name.match(new RegExp('contact' + '\\[' + field + '\\(?'))
        )
        input.addClass('tooltipstered')
        input.tooltipster
          animation: 'grow' # or fade
          theme: 'tooltipster-msg'
          maxWidth: 220
          position: 'top-left'
          onlyOne: true
          offsetY: -3 # 0 with position left
        input.tooltipster('content', $('<div>' + $.map(messages, (m) -> m.charAt(0).toUpperCase() + m.slice(1)).join('<br />') + '</span>'))
        input.tooltipster('enable')
        input.tooltipster('show')
        input.on 'input', (e) ->
          input.tooltipster('disable')
          input.removeClass('tooltipstered')
      )
