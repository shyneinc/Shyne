ShyneDirectives.directive('popCard', () ->
  (scope, element) ->
    element.on('mouseenter', () ->
      element.animate({marginTop: '-=20'}, 100)
    ).on('mouseleave', () ->
      element.animate({marginTop: '+=20'}, 100)
    )
)

ShyneDirectives.directive('starRating', () ->
  restrict: 'E'
  template: "<ul style=\"padding: 0;font-size:24px;\">" +
            "<li ng-repeat=\"star in stars\" style=\"color: #FF860D;\"" +
            "class=\"glyphicon\" ng-class=\"{true: \'glyphicon-star-empty\', false: 'glyphicon-star'}[star.empty]\"></li></ul>"
  link: (scope) ->
    scope.$watch "starRating", (oldVal, newVal) ->
      scope.stars = []
      maxStarRating = scope.maxStarRating
      i = 0

      while i < scope.maxStarRating
        scope.stars.push
          empty: true
          index: i + 1
        i++

      scope.stars = []
      starRating = scope.starRating
      i = 0

      while i < scope.maxStarRating
        scope.stars.push
          empty: i >= starRating
          index: i + 1
        i++
  scope:
    starRating: "="
    maxStarRating: "="
    ratingChanged: "&"
)


ShyneDirectives.directive("stopEvent", ->
  restrict: "A"
  link: (scope, element, attr) ->
    element.bind "click", (e) ->
      e.stopPropagation()

)

ShyneDirectives.directive("ngConfirmClick", ->
  restrict: 'A'
  link: (scope, element, attr) ->
    msg = attr.ngConfirmClick or "Are you sure?"
    clickAction = attr.confirmedClick
    element.bind "click", (event) ->
      scope.$eval clickAction  if window.confirm(msg)
      return

    return
)