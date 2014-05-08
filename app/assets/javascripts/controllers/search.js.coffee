Shyne.controller('SearchCtrl', ['$location','$rootScope', '$scope','$timeout','$routeParams','Session', ($location, $rootScope, $scope, $timeout, $routeParams, Session) ->

  $rootScope.location = $location
  $scope.user = null
  $scope.search_text = $routeParams.q
  $scope.search_mentors = null
  $scope.searchModel = { search_text: null }
  $scope.loading = false
  $rootScope.industries = []
  $rootScope.schools = []

  Session.getCurrentUser(false).then((user)->
    $scope.user = user
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
