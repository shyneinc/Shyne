Shyne.controller('ProfileCtrl', ($scope, Session) ->

  Session.requestCurrentUser().then((user)->
    $scope.user =  user
  )

  $scope.logout = ->
    Session.logout()

)