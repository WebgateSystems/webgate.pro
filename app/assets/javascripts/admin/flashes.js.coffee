#FadeOut for all alerts in admin
flashCallback = ->
    $(".flash").animate
      height: 0
      opacity: 0
    , 350
    , ->
      $(this).remove()

$ ->
    $(".flash").bind 'click', (ev) =>
        flashCallback()
    setTimeout flashCallback, 3800
