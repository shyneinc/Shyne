ShyneDirectives.directive('popCard', () ->
  (scope, element) ->
    element.on('mouseenter', () ->
      element.animate({marginTop: '-=20'}, 100)
    ).on('mouseleave', () ->
      element.animate({marginTop: '+=20'}, 100)
    )
)

ShyneDirectives.directive('starRatingOrange', () ->
  restrict: 'E'
  template: "<span class=\"spOrg{{ stars }}\"></span>"
  link: (scope) ->
    scope.$watch "starRating", (oldVal, newVal) ->
      scope.stars = ' star-0-0'
      starRating = scope.starRating
      if starRating > 0
        scope.stars = ' star-' + starRating.toString().replace(".", "-")

  scope:
    starRating: "="
    ratingChanged: "&"
)

ShyneDirectives.directive('starRatingBlue', () ->
  restrict: 'E'
  template: "<span class=\"fr spBlue {{ stars }}\"></span>"
  link: (scope) ->
    scope.$watch "starRating", (oldVal, newVal) ->
      scope.stars = ' star-0-0'
      starRating = scope.starRating
      if starRating > 0
        scope.stars = ' star-' + starRating.toString().replace(".", "-")

  scope:
    starRating: "="
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

ShyneDirectives.directive('fancyCheckbox', () ->
  (scope, element) ->
    element.on('click', () ->
      if $(".checkBtn input").length
        $(".checkBtn").each ->
          $(this).removeClass "c_on"
          return

        $(".checkBtn input:checked").each ->
          $(this).parent("span").addClass "c_on"
          return

      if $(".radioBtn input").length
        $(".radioBtn").each ->
          $(this).removeClass "r_on"
          return

        $(".radioBtn input:checked").each ->
          $(this).parent("span").addClass "r_on"
          return
    )
)