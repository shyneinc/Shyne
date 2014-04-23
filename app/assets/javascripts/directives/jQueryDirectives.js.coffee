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

ShyneDirectives.directive("openDialog", ->
  restrict: "A"
  openDialog = link: (scope, element, attrs) ->
    openDialog = ->
      element = $(attrs.modalName)
      element.modal "show"

      element.on "keyup.dismiss.bs.modal", $.proxy((e) ->
        if e.isDefaultPrevented()
          return
        if e.which is 27
          scope.$apply "cancel()"
          element.modal "hide"
        return
      , this)

    element.bind "click", openDialog
    return

  openDialog
)

ShyneDirectives.directive('resizable', ($window) ->
  (scope, element) ->
    w = angular.element($window)
    scope.getWindowDimensions = ->
      h: w.height()
      w: w.width()

    scope.$watch scope.getWindowDimensions, ((newValue, oldValue) ->
      scope.windowHeight = newValue.h
      scope.windowWidth = newValue.w

      # Footer position
      windowHeight = newValue.h
      wrapperHeight = (newValue.h - $(".footer").outerHeight())
      if $("footer").outerHeight() < 82
        footerHeight = 138
      else
        footerHeight = $("footer").outerHeight()

      $(".wrapper").css
        "padding-bottom": footerHeight
        "min-height": windowHeight

      $(".ie7 .wrapper").css
        "padding-bottom": footerHeight
        "min-height": wrapperHeight

      return
    ), true

    w.bind "resize", ->
      scope.$apply()
      return

    return
)

ShyneDirectives.directive('carousel', () ->
  (scope, element) ->
    $(element).carousel({interval: false})
)

ShyneDirectives.directive('nextCarousel', () ->
  (scope, element) ->
    element.on('click', () ->
      carousel = $('#carousel')
      this.$active = carousel.find('.item.active')
      this.$items = this.$active.parent().children()
      return if (this.$items.index(this.$active) == this.$items.length - 1)
      carousel.carousel('next')
    )
)

ShyneDirectives.directive('prevCarousel', () ->
  (scope, element) ->
    element.on('click', () ->
      carousel = $('#carousel')
      this.$active = carousel.find('.item.active')
      this.$items = this.$active.parent().children()
      return if (this.$items.index(this.$active) == 0)
      carousel.carousel('prev')
    )
)