ShyneDirectives.directive('btModal', () ->
  (scope, element, attrs) ->
    $content = $(element.attr('href'))
    scope.$watch(attrs.btModal, (v) ->
      $content.modal('hide')
    )
    element.click((e)->
      e.preventDefault()
      $content.on('shown.bs.modal',()->
        $content.find('form').find('.auto-focus').focus()
      ).modal()
    );
)