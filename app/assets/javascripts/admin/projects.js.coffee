$(document).on('ready', ()->
  onAddFile = (event) ->
    file = event.target.files[0]
    url = URL.createObjectURL(file)

    thumbContainer = $(this).parent().siblings('td.thumb')
    if thumbContainer.find('img').length == 0
      thumbContainer.append('<img src="' + url + '" />')
    else
      thumbContainer.find('img').attr('src', url)

  # for redisplayed file inputs and file inputs in edit page
  $('input[type=file]').each(()->
      $(this).change(onAddFile)
  )

  # register event handler when new cocoon partial is inserted from link_to_add_association link
  $('body').on('cocoon:after-insert', (e, addedPartial) ->
    $('input[type=file]', addedPartial).change(onAddFile)
  )

  # tell cocoon where to insert partial
  $('a.add_fields').data('association-insertion-method', 'append')
  $('a.add_fields').data('association-insertion-node', 'table.project-form tbody')
)

ready = undefined

set_positions = undefined
set_positions = -> 
  # loop through and give each screenshot a data-pos
  # attribute that holds its position in the DOM
  $('li#screenshot').each (i) ->
    $(this).attr 'data-pos', i + 1
    return
  return

ready = ->
  # call set_positions function
  set_positions()
  # call sortable on our element with the sortable class
  $('.sortable').sortable()

  # after the order changes
  $('.sortable').sortable().bind 'sortupdate', (e, ui) ->
    # array to store new order
    updated_order = []
    # set the updated positions
    set_positions()
    # populate the updated_order array with the new screenshot positions
    $('li#screenshot').each (i) ->
      updated_order.push
        id: $(this).data('id')
        position: i + 1
      return
    
    # send the updated order via ajax
    project_id = $('li#screenshot').attr('data-project_id')
    $.ajax
      type: 'PUT'
      url: "/admin/projects/#{project_id}" + "/sort"
      data:
        order: updated_order
    return

  return

$(document).ready ready

# if using turbolinks
$(document).on 'page:load', ready