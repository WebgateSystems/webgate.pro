#--------------------------COCOON
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
  $('a.add_fields').data('association-insertion-node', 'table.member-form tbody')
)


#----------------------CHOSEN FOR TECHS SELECT
$ ->
  # enable chosen js
  $('.chosen-select').chosen
    allow_single_deselect: true
    no_results_text: 'No results matched'
    width: '100%'


#----------------------MEMBERS REORDERING
$ ->
  if $('.members#sortable').length > 0

    $('.members#sortable').sortable(
      axis: 'y'
      items: '.item'
      cursor: 'move'

      sort: (e, ui) ->
        ui.item.addClass('active-item-shadow')
      stop: (e, ui) ->
        ui.item.removeClass('active-item-shadow')
        # highlight the row on drop to indicate an update
        ui.item.children('td').effect('highlight', {}, 1000)
      update: (e, ui) ->
        item_id = ui.item.data('item-id')
        position = ui.item.index()
        $.ajax(
          type: 'PUT'
          url: '/admin/members/update_position'
          dataType: 'json'
          data: { member: { member_id: item_id, row_position: position } }
        )
    )

#----------------------MEMBERLINKS REORDERING
$ ->
  if $('.links#sortable').length > 0
    $('.links#sortable').sortable(
      axis: 'y'
      items: '.item'
      cursor: 'move'

      sort: (e, ui) ->
        ui.item.addClass('active-item-shadow')
      stop: (e, ui) ->
        ui.item.removeClass('active-item-shadow')
        # highlight the row on drop to indicate an update
        ui.item.children('td').effect('highlight', {}, 1000)
      update: (e, ui) ->
        item_id = ui.item.data('item-id')
        parent_id = ui.item.data('parent-id')
        position = ui.item.index()
        $.ajax(
          type: 'PUT'
          url: "/admin/members/#{parent_id}" + "/sort_member_links"
          dataType: 'json'
          data: { member: { member_link_id: item_id, row_position: position } }
        )
    )
