Shyne.controller('HomeCtrl', ['$location', '$rootScope', '$scope','Session',($location, $rootScope, $scope, Session) ->

  $rootScope.location = $location
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

  $scope.search = () ->
    search_location = "/search/#{$scope.searchModel.search_text}"
    $location.path search_location

  $scope.viewProfile = (user_id) ->
    $location.path('/profile/' + user_id)

])
