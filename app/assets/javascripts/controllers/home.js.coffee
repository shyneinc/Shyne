Shyne.controller('HomeCtrl', ['$location', '$rootScope', '$scope','Session',($location, $rootScope, $scope, Session) ->

  $rootScope.location = $location
  $scope.showIndex = true
  $scope.signupModel = {timeZone: 'Alaska'}
  $scope.signUpError = {}
  $scope.user = null
  $scope.featured_mentors = null
  $scope.searchModel = { search_text: '' }

  Session.getCurrentUser(false).then((user)->
    $scope.user = user
  )

  Session.getFeaturedMentors().then((data)->
    $scope.featured_mentors = _.shuffle(data).chunk(3)
  )

  #chunk array in multi dimensional array
  Array::chunk = (chunkSize) ->
    R = []
    i = 0

    while i < @length
      R.push @slice(i, i + chunkSize)
      i += chunkSize
    R

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

  $scope.search = () ->
    search_location = "/search/#{$scope.searchModel.search_text}"
    $location.path search_location

  $scope.go = (path) ->
    $location.path(path)

  $scope.viewProfile = (user_id) ->
    $location.path('/profile/' + user_id)

])
