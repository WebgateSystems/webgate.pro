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
  $('a.add_fields').data('association-insertion-node', 'table.project-form tbody')
)


#----------------------CHOSEN FOR TECHS SELECT
$ ->
  # enable chosen js
  $('.chosen-select').chosen
    allow_single_deselect: true
    no_results_text: 'No results matched'
    width: '100%'

  $('#project_technology_ids option:selected').each () ->
    inuse_id = $(this).attr('value')
    col = $('option[value='+inuse_id+']').data('color')
    if (typeof col != "undefined")
      name = $('option[value='+inuse_id+']').text()
      $('ul.chosen-choices li.search-choice span:contains('+name+')').parent().css('background-image', 'linear-gradient('+col+' 20%, '+col+' 50%, '+col+' 52%, '+col+' 100%)')

  $(".chosen-select").chosen().on 'change', (ev, par) ->
    id = par['selected']
    col = $('option[value='+id+']').data('color')
    if (typeof col != "undefined")
      name = $('option[value='+id+']').text()
      fake_id = $('ul.chosen-results li:contains('+name+')').attr("data-option-array-index")
      $('a[data-option-array-index='+fake_id+']').parent().css('background-image', 'linear-gradient('+col+' 20%, '+col+' 50%, '+col+' 52%, '+col+' 100%)')


#----------------------PROJECTS REORDERING
$ ->
  if $('.projects#sortable').length > 0

    $('.projects#sortable').sortable(
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
          url: '/admin/projects/update_position'
          dataType: 'json'
          data: { project: { project_id: item_id, row_position: position } }
        )
    )

#----------------------PROJECT SCREENSHOTS REORDERING
$ ->
  if $('.screenshots#sortable').length > 0
    $('.screenshots#sortable').sortable(
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
          url: "/admin/projects/#{parent_id}" + "/sort_project_screenshots"
          dataType: 'json'
          data: { project: { screenshot_id: item_id, row_position: position } }
        )
    )

#----------------------PROJECT TECHNOLOGIES REORDERING
$ ->
  if $('.technologies#sortable').length > 0
    $('.technologies#sortable').sortable(
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
          url: "/admin/projects/#{parent_id}" + "/sort_project_technologies"
          dataType: 'json'
          data: { project: { project_technology_id: item_id, row_tech_position: position } }
        )
    )
