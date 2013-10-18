ShyneDirectives.directive('scrollTo', () ->
  (scope, element) ->
    element.on('click', (e) ->
      e.preventDefault();
      console.log($(element.attr('href') + '-mark'));
      jQuery('html, body').animate({
        scrollTop: jQuery(element.attr('href') + '-mark').offset().top
      }, 400)
    )
)