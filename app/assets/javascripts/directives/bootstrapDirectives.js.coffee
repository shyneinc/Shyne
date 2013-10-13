ShyneDirectives.directive('btModal', () ->
  (scope, element) ->
    $content = $(element.attr('href'))
    element.click((e)->
      e.preventDefault()
      $content.on('shown.bs.modal', ()->
        $content.find('form').find('.auto-focus').focus().end().submit( () ->
          $content.modal('hide')
        )
      ).modal()
    );
)