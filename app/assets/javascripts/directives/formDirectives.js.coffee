ShyneDirectives.directive('confirmField', () ->
  {
    require: 'ngModel',
    link: (scope, elm, attrs, ctrl) ->
      field = '#' + attrs.confirmField
      elem.add(field).on('keyup', () ->
        scope.$apply(()->
          v = elm.val() == $(field).val()
          ctrl.$setValidity('fieldMatch', v)
        )
      )
  }
)