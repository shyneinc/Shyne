ShyneDirectives.directive('scrollTo', () ->
  (scope, element) ->
    element.on('click', (e) ->
      e.preventDefault();
      jQuery('html, body').animate({
        scrollTop: jQuery(element.attr('href') + '-mark').offset().top
      }, 400)
    )
)

ShyneDirectives.directive('rollUp', () ->
  (scope, element) ->
    element.click((e)->
      e.preventDefault()
      idx = element.attr('roll-up')
      boxUp = jQuery('.box-' + (parseInt(idx, 10) + 1).toString())
      jQuery('.box-' + idx.toString()).animate({top: '+=20'}, 200).animate({top: -1100}, 400, () ->
        boxUp.animate({top: 28}, 300).animate({top: '+=20'}, 200, () ->
          boxUp.find('.flash-1').animate({opacity: 1}, 400, () ->
            boxUp.find('.flash-2').animate({opacity: 1}, 600, () ->
              boxUp.find('.flash-3').animate({opacity: 1}, 600)
            )
          )
        )
      )
    )
)

ShyneDirectives.directive('rollDown', () ->
  (scope, element) ->
    element.click((e)->
      e.preventDefault()
      idx = element.attr('roll-down')
      boxDown = jQuery('.box-' + (parseInt(idx, 10) - 1).toString())
      jQuery('.box-' + idx.toString()).animate({top: '-=20'}, 200).animate({top: 2100}, 400, () ->
        boxDown.animate({top: 68}, 300).animate({top: '-=20'}, 200)
      )
    )
)

ShyneDirectives.directive('toggleSubInfo', () ->
  (scope, element) ->
    subInfo = element.find('.sub-info')
    element.on('mouseenter', () ->
      subInfo.removeClass('hidden')
    ).on('mouseleave', () ->
      subInfo.addClass('hidden')
    )
)

ShyneDirectives.directive('handleSwipe', () ->
  (scope, element) ->
    jQuery(element).bind('swipeUp', ()->
      console.log('swipe up')
    ).bind('swipeDown', () ->
      console.log('swipe down')
    ).swipeEvents()
)