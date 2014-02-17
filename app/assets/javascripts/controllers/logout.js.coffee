Shyne.controller('LogoutCtrl', ($location, $scope, Session) ->

  Session.logout().then(
    (user)->
      $location.path '/'
  )


)