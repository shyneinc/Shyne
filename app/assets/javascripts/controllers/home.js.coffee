Shyne.controller('HomeCtrl', ($location, $scope, Session) ->

  $scope.$parent.showIndex = false

  $scope.signin = () ->
    u = $scope.login
    Session.login(u.email, u.password).then(
      ()->
        $location.path '/profile'
    , (error)->
      $scope.error = error
    )

  $scope.signup = () ->
    u = $scope.signup
    Session.register(u.email, u.password, u.confirmPassword).then(
      ()->
        $location.path '/profile'
    , ()->
      $scope.error = error
    )

)