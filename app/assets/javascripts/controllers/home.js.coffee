Shyne.controller('HomeCtrl', ['$location','$scope','Session',($location, $scope, Session) ->

  $scope.showIndex = true
  $scope.signupModel = {timeZone: 'Alaska'}
  $scope.signUpError = {}
  $scope.user = null

  Session.getCurrentUser().then((user)->
    $scope.user = user
  )

  mentorIdx = 0

  mentors = [
    {id: 1, name: 'Rohan Jain', role: 'Product', company: 'Shyne', ratePerMinute: 3, photoUrl: '/assets/sample/rohan.jpg'},
    {id: 1, name: 'Jesal Gadhia', role: 'Engineer', company: 'Shyne', ratePerMinute: 5, photoUrl: '/assets/sample/jesal.jpg'},
    {id: 1, name: 'Audee Velasco', role: 'Design', company: 'Shyne', ratePerMinute: 4, photoUrl: '/assets/sample/audee.jpg'},
    {id: 1, name: 'Tim Wong', role: 'Engineer', company: 'Shyne', ratePerMinute: 3, photoUrl: '/assets/sample/tim.jpg'},
    {id: 1, name: 'Snowy', role: 'Security', company: 'Shyne', ratePerMinute: 10, photoUrl: '/assets/sample/snowy.jpg'},
    {id: 1, name: 'Mr. Smith', role: 'Manger', company: 'Smith Co.', ratePerMinute: 20, photoUrl: '/assets/sample/smith.jpg'}
  ]

  $scope.mentors = mentors.splice(mentorIdx, 4)

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
