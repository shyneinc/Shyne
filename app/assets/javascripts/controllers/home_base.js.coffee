Shyne.controller('HomeBaseCtrl', ['$location','$scope','Session',($location, $scope, Session) ->

  $scope.showIndex = true
  $scope.signupModel = {timeZone: 'Alaska'}
  $scope.signUpError = {}
  $scope.user = null

  Session.getCurrentUser().then((user)->
    $scope.user = user
  )

  $scope.login = () ->
    u = $scope.loginModel
    Session.login(u.email, u.password).then(
      (user)->
        $location.path '/profile/'
    , (error)->
      $scope.loginError = error
    )

  $scope.signup = () ->
    u = $scope.signupModel
    Session.register(u.firstName, u.lastName, u.email, u.password, u.confirmPassword, u.timeZone).then(
      (user)->
        $location.path '/profile/'
    , (error)->
      $scope.signUpError = error
    )

  $scope.logout = () ->
    $scope.user = null
    Session.logout().then(() ->
      $scope.user = null
    )

])
