Shyne.controller('HomeBaseCtrl', ['$location','$scope','$timeout','$routeParams','Session','Confirmation', ($location, $scope, $timeout, $routeParams, Session, Confirmation) ->

  $scope.showIndex = true
  $scope.signupModel = {timeZone: 'Alaska'}
  $scope.signUpError = {}
  $scope.user = null
  $scope.token = $routeParams.token

  Session.getCurrentUser(false).then((user)->
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

  $scope.verify = () ->
    Confirmation.verify($scope.token).then(
      () ->
        $scope.flash_message = "Thank you! Your email has been verified."
        $timeout (->
          $scope.flash_message = null
          $location.path '/profile/'
        ), 200
    , (error)->
      $scope.flash_message = error[0]
      $timeout(->
        $scope.flash_message = null
      , 5000)
    )

  if $routeParams.token != null
    $scope.verify()
])
