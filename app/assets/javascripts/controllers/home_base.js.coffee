Shyne.controller('HomeBaseCtrl', ['$location','$rootScope', '$scope','$timeout','$routeParams','Session','Confirmation', ($location, $rootScope, $scope, $timeout, $routeParams, Session, Confirmation) ->

  $rootScope.location = $location
  $scope.showIndex = true
  $scope.signupModel = {timeZone: 'Pacific Time (US & Canada)'}
  $scope.signUpError = {}
  $scope.user = null
  $scope.token = $routeParams.token
  $scope.search_text = $routeParams.q
  $scope.search_mentors = null
  $scope.searchModel = { search_text: null }
  $scope.loading = false

  Session.getCurrentUser(false).then((user)->
    $scope.user = user
  )

  $scope.login = () ->
    $scope.loading = true
    u = $scope.loginModel
    Session.login(u.email, u.password).then(
      (user)->
        $scope.loading = false
        $location.path '/profile/'
    , (error)->
      $scope.loading = false
      $scope.loginError = error
    )

  $scope.signup = () ->
    $scope.loading = true
    u = $scope.signupModel
    Session.register(u.firstName, u.lastName, u.email, u.password, u.confirmPassword, u.timeZone).then(
      (user)->
        $scope.loading = false
        $location.path '/profile/'
    , (error)->
      $scope.loading = false
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
      if $scope.user != null
        $scope.flash_message = "Your email is already verified."
        $timeout (->
          $scope.flash_message = null
          $location.path '/profile/'
        ), 500
        return
      $scope.flash_message = error[0]
      $timeout(->
        $scope.flash_message = null
      , 5000)
    )

  if $routeParams.token != undefined && $routeParams.token != null
    $scope.verify()

  $scope.viewProfile = (user_id) ->
    $location.path('/profile/' + user_id)

  Session.searchMentors($scope.search_text).then((data)->
    $scope.searchModel.search_text = $routeParams.q
    if data.info
      $scope.searchError = data
      data = []
    $scope.search_mentors = data
  )
])
