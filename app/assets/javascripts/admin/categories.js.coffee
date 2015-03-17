#----------------------CATEGORIES REORDERING
$ ->
  if $('#sortable').length > 0

    $('#sortable').sortable(
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
          url: '/admin/categories/update_position'
          dataType: 'json'
          data: { category: { category_id: item_id, row_position: position } }
        )
    )
