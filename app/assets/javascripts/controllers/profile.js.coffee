Shyne.controller('ProfileCtrl', ['$scope','Session',($scope, Session) ->

  $scope.$parent.showIndex = false

  Session.requestCurrentUser().then((user)->
    $scope.user =  user
  )

  $scope.logout = ->
    Session.logout()

])