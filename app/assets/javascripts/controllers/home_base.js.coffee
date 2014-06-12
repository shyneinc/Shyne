Shyne.controller('HomeBaseCtrl', ['$location','$rootScope', '$scope','$timeout','$routeParams','Session','Confirmation', 'User', 'Workhistory', ($location, $rootScope, $scope, $timeout, $routeParams, Session, Confirmation, User, Workhistory) ->

  $rootScope.location = $location
  $scope.signupModel = {timeZone: 'Pacific Time (US & Canada)'}
  $scope.signUpError = {}
  $scope.user = null
  $scope.token = $routeParams.token
  $scope.loading = false
  $rootScope.industries = null
  $rootScope.schools = null
  $rootScope.creditCardInfo = null
  $rootScope.bankAccountInfo = null

  Session.getCurrentUser(false).then((user)->
    $scope.user = user
  )

  $scope.login = () ->
    $scope.loading = true
    u = $scope.loginModel
    Session.login(u.email, u.password).then(
      (user)->
        $scope.prepareIndustriesAndSchools()
        $scope.loading = false
        if $rootScope.previousUrl
          oldUrl = $rootScope.previousUrl.replace "#", ""
          rootArray = ["/", "/login", "/logout", "/signup", "/how", "/our-mission", "/search"]
          if oldUrl not in rootArray
            $location.path(oldUrl)
          else
            $location.path '/profile/'
        else
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
        $scope.prepareIndustriesAndSchools()
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

  $scope.verify = () ->
    Confirmation.verify($scope.token).then(
      () ->
        $scope.prepareIndustriesAndSchools()
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

  $scope.prepareIndustriesAndSchools = () ->
    $rootScope.industries = []
    $rootScope.schools = []
    Workhistory.getIndustries().then((industries) ->
      for i in industries
        $rootScope.industries.push(i[1])
    )

    User.getSchools().then((schools) ->
      for i in schools
        $rootScope.schools.push(i[1])
    )
])
