ShyneDirectives.directive('autoFocus', () ->
  (scope, element) ->
    element.focus()
)

ShyneDirectives.directive('startInlineEdit', () ->
  (scope, element) ->
    element.click(() ->
      element.parents('.editable-field').find('.edit-form').show()
    )
)

ShyneDirectives.directive('hideInlineEdit', () ->
  (scope, element) ->
    element.click(() ->
      element.parents('.editable-field').find('.edit-form').hide()
    )
)

ShyneDirectives.directive('hideFlashMessage', () ->
  (scope, element) ->
    element.click(() ->
      scope.flash_message = null
      scope.$digest()
    )
)