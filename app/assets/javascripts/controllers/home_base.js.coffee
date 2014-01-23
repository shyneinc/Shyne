Shyne.controller('HomeBaseCtrl', ['$location','$scope','$timeout','$routeParams','Session','Confirmation', ($location, $scope, $timeout, $routeParams, Session, Confirmation) ->

  $scope.showIndex = true
  $scope.signupModel = {timeZone: 'Pacific Time (US & Canada)'}
  $scope.signUpError = {}
  $scope.user = null
  $scope.token = $routeParams.token
  $scope.search_text = $routeParams.q
  $scope.search_mentors = null
  $scope.searchModel = { search_text: null }

  Session.getCurrentUser(false).then((user)->
    $scope.user = user
  )

  Session.searchMentors($scope.search_text).then((data)->
    $scope.searchModel.search_text = $routeParams.q
    $scope.search_mentors = data
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
        $location.path '/confirmation/'
    , (error)->
      $scope.signUpError = error
    )

  $scope.logout = () ->
    $scope.user = null
    Session.logout().then(() ->
      $scope.user = null
    )

  $scope.searchMentors = () ->
    search_text = $scope.searchModel.search_text
    Session.searchMentors(search_text).then(
      (data)->
        if data.info
          $scope.searchError = data
          data = []
        $scope.search_mentors = data
    , (error)->
      $scope.signUpError = error
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
