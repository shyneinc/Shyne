Shyne.controller('SearchCtrl', ['$location','$rootScope', '$scope','$timeout','$routeParams','Session', 'Search', ($location, $rootScope, $scope, $timeout, $routeParams, Session, Search) ->

  $rootScope.location = $location
  $scope.user = null
  $scope.search_text = $routeParams.q
  $scope.search_advisors = null
  $scope.searchModel = { search_text: null }
  $scope.loading = false
  $rootScope.industries = []
  $rootScope.schools = []

  Session.getCurrentUser(false).then((user)->
    $scope.user = user
  )

  $scope.searchAdvisors = () ->
    search_text = $scope.searchModel.search_text
    Search.searchAdvisors(search_text).then(
      (data)->
        if data.info
          $scope.searchError = data
          data = []
        $scope.search_advisors = data
    , (error)->
      $scope.signUpError = error
    )

  $scope.viewProfile = (user_id) ->
    $location.path('/profile/' + user_id)

  Search.searchAdvisors($scope.search_text).then((data)->
    $scope.searchModel.search_text = $routeParams.q
    if data.info
      $scope.searchError = data
      data = []
    $scope.search_advisors = data
  )
])
