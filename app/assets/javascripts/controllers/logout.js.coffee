Shyne.controller('LogoutCtrl', ($location, $scope, $rootScope, Session) ->

  $rootScope.creditCardInfo = null
  Session.logout().then(
    (user)->
      $location.path '/'
  )


)