ShyneDirectives.directive('autoFocus', () ->
  (scope, element) ->
    element.focus()
)

ShyneDirectives.directive('hideFlashMessage', () ->
  (scope, element) ->
    element.click(() ->
      scope.flash_message = null
      scope.$digest()
    )
)

ShyneDirectives.directive("datepicker", () ->
  restrict: "A"
  require: "ngModel"
  link: (scope, el, attr, ngModel) ->
    el.datepicker
      dateFormat:'mm-dd-yy'
      onSelect: (dateText) ->
        scope.$apply ->
          ngModel.$setViewValue dateText
)

ShyneDirectives.directive('timepicker', () ->
  require: "ngModel"
  link: (scope, el, attr, ngModel) ->
    $(el).timepicker
      timeFormat: 'h:i'
      useSelect : true
      noneOption: true
      className: 'form-control width40'
      minTime: '01:00am'
      maxTime: '12:30am'
    el.change(() ->
      selectedValue = $(this).val()
      scope.$apply ->
        ngModel.$setViewValue selectedValue
    )
)

ShyneDirectives.directive('hideFooterFlashMessage', () ->
  (scope, element) ->
    element.click(() ->
      scope.footer_flash_message = null
      scope.$digest()
    )
)