ShyneDirectives.directive('popCard', () ->
  (scope, element) ->
    element.on('mouseenter', () ->
      element.animate({marginTop: '-=20'}, 100)
    ).on('mouseleave', () ->
      element.animate({marginTop: '+=20'}, 100)
    )
)