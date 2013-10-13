Shyne.controller('SignupCtrl', ($scope, Session) ->
  $scope.signup = () ->
    u = $scope.user
    Session.register(u.firstName, u.lastName, u.email, u.password)
)