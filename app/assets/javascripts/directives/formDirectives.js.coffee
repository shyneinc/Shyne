ShyneDirectives.directive('confirmField', () ->
  (scope, element, attrs, ctrl) ->
    field = '#' + attrs.confirmField
    element.add(field).on('keyup', () ->
      scope.$apply(()->
        v = element.val() == $(field).val()
        console.log(v)
#        ctrl.$setValidity('fieldMatch', v)
      )
    )
)