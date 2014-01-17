Shyne.controller('HomeCtrl', ['$location','$scope','Session',($location, $scope, Session) ->

  $scope.showIndex = true
  $scope.signupModel = {timeZone: 'Alaska'}
  $scope.signUpError = {}
  $scope.user = null
  $scope.mentors = null

  Session.getCurrentUser(false).then((user)->
    $scope.user = user
  )

  mentorIdx = 0

  Session.getFeaturedMentors().then((data)->
    $scope.mentors = data.splice(mentorIdx, 4)
  )

  $scope.viewProfile = (mentor) ->
    $location.path '/profile/'

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
