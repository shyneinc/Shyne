Shyne.controller('UsersCtrl', ($scope, Session) ->
  $scope.login = (user) ->
    $scope.authError = null
    Session.login(user.email, user.password).then ((response) ->
      unless response
        $scope.authError = "Credentials are not valid"
      else
        $scope.authError = "Success!"
    ), (response) ->
      $scope.authError = "Server offline, please try later"


  $scope.logout = (user) ->

  $scope.register = (user) ->
    $scope.authError = null
    Session.register(user.email, user.password, user.confirm_password).then ((response) ->
      console.log response
    ), (response) ->
      errors = ""
      $.each response.data.errors, (index, value) ->
        errors += index.substr(0, 1).toUpperCase() + index.substr(1) + " " + value + ""

      $scope.authError = errors

)