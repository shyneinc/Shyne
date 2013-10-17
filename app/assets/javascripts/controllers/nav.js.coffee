Shyne.controller('NavCtrl', ($location, $scope, Session) ->

  $scope.isLoggedIn = false

  $scope.signin = () ->
    u = $scope.login
    Session.login(u.email, u.password).then(
      ()->
        $scope.isLoggedIn = true
        $location.path '/profile'
    , (error)->
      $scope.error = error
    )

  $scope.signout = () ->
    Session.logout().then( ()->
      $scope.isLoggedIn = false
      $location.path '/'
    )

  $scope.signup = () ->
    u = $scope.signup
    Session.register(u.email, u.password, u.confirmPassword).then(
      ()->
        $scope.isLoggedIn = true
        $location.path '/profile'
    , (error)->
      $scope.error = error
    )

  $scope.signout

)