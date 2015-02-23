$ ->
  # enable chosen js
  $('.chosen-select').chosen
    allow_single_deselect: true
    no_results_text: 'No results matched'
    width: '100%'

  $('#member_technology_ids option:selected').each () ->
    inuse_id = $(this).attr('value')
    console.log(inuse_id)
    col = $('option[value='+inuse_id+']').data('color')
    if (typeof col != "undefined")
      name = $('option[value='+inuse_id+']').text()
      $('ul.chosen-choices li.search-choice span:contains('+name+')').parent().css('background-image', 'linear-gradient('+col+' 20%, '+col+' 50%, '+col+' 52%, '+col+' 100%)')


  $(".chosen-select").chosen().on 'change', (ev, par) ->
    id = par['selected']
    col = $('option[value='+id+']').data('color')
    name = $('option[value='+id+']').text()
    fake_id = $('ul.chosen-results li:contains('+name+')').attr("data-option-array-index")
    $('a[data-option-array-index='+fake_id+']').parent().css('background-image', 'linear-gradient('+col+' 20%, '+col+' 50%, '+col+' 52%, '+col+' 100%)')

