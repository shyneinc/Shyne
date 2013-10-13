Shyne.controller('LoginCtrl', ($scope, Session) ->

  $scope.login = () ->
    u = $scope.user
    Session.login(u.email, u.password)

)