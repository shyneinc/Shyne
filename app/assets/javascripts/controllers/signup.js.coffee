Shyne.controller('SignupCtrl', ($location, $scope, Session) ->
  $scope.signup = () ->
    u = $scope.user
    Session.register(u.email, u.password, u.confirmPassword).then(
      ()->
        $location.path '/profile'
    , ()->
        $scope.error = error
    )
)