#----------------------TECHNOLOGY GROUPS REORDERING
$ ->
  if $('.index#sortable').length > 0
    $('.index#sortable').sortable(
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
          url: '/admin/technology_groups/update_position'
          dataType: 'json'
          data: { technology_group: { technology_group_id: item_id, row_position: position } }
        )
    )


#----------------------TECHNOLOGIES REORDERING
$ ->
  if $('.show#sortable').length > 0
    $('.show#sortable').sortable(
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
        technology_group_id = $('tr#item').attr('data-technology_group_id')
        $.ajax(
          type: 'PUT'
          url: "/admin/technology_groups/#{parent_id}" + "/sort"
          dataType: 'json'
          data: { technology_group: { technology_id: item_id, row_position: position } }
        )
    )
