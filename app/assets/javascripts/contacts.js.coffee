# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$("#new_contact").on("ajax:success", (e, data, status, xhr) ->
    console.log("complete!")
    console.log(data)
    console.log(xhr)
    console.log(status)
  ).on("ajax:error", (e, data, status, xhr) ->
    console.log("error!")
    console.log(data)
    console.log(xhr)
    console.log(status)
    if data.error
      for message of data
        $('.content').append '<li>' + data.error[message] + '</li>'
)
