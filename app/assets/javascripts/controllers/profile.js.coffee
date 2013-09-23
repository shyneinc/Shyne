Shyne.controller('ProfileCtrl', ($scope, Session) ->
  $scope.user = Session.requestCurrentUser()
  $scope.logout = ->
    Session.logout()
)