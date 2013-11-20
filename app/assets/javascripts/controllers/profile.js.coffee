Shyne.controller('ProfileCtrl', ['$scope','Session',($scope, Session) ->

  Session.getCurrentUser().then((user)->
    $scope.user =  user
  )

  $scope.logout = ->
    Session.logout()

])
