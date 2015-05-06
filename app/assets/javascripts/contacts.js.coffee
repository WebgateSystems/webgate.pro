# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).ready ->
  $("#new_contact")
    .on "ajax:success", (event, data, status, xhr) ->
      console.log("success!")
      console.log(data)
      console.log(xhr.responseText)
      console.log(status)
      $(".content").append("<li>" + data['name'] + "</li>")
      $("#new_contact")[0].reset();
      $.getScript(document.location.href = "/contact_complete")
    .on "ajax:error", (event, data, status, xhr) ->
      console.log("error!")
      console.log(data.responseJSON)
      console.log(xhr)
      console.log(status)
      $.each(data.responseJSON, (field, messages) ->
        console.log(field)
        console.log(messages)
        #input = $("new_contact").find('input, select, textarea').filter( ->
        #  name = $(this).attr('name')
        #  if name
        #    name.match(new RegExp(model_name + '\\[' + field + '\\(?'))
        #)
      )
      #$("#new_contact")[0].reset();
