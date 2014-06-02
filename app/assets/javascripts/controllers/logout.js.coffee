Shyne.controller('LogoutCtrl', ($location, $scope, $rootScope, Session) ->

  $rootScope.creditCardInfo = null
  $rootScope.bankAccountInfo = null
  Session.logout().then(
    (user)->
      $location.path '/'
  )


)