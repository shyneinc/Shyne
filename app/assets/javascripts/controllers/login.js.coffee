Shyne.controller('LoginCtrl', ($scope, $location, Session) ->

  $scope.login = () ->
    u = $scope.user
    Session.login(u.email, u.password).then(
      ()->
        $location.path '/profile'
    , (error)->
        $scope.error = error
    )

)