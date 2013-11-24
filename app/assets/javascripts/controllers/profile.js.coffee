Shyne.controller('ProfileCtrl', ['$scope','Session', 'User',($scope, Session, User) ->

  $scope.user = null
  $scope.welcomeModel = {role: null}

  Session.getCurrentUser().then((user)->
    $scope.user = user
    if user.role_type is 'Member'
      User.getMemberInfo(user.id).then((memberInfo) ->
        angular.extend(user, memberInfo)
      )
  )

  $scope.showMemberForm = () ->
    $scope.welcomeModel.role = 'Member'

  $scope.showMentorForm = () ->
    $scope.welcomeModel.role = 'Mentor'

  $scope.clearRole = () ->
    $scope.welcomeModel.role = null

  $scope.becomeMember = () ->
    User.becomeMember($scope.memberModel.phoneNumber).then((data)->
      console.log(data)
    , (data)->
      $scope.memberFormError = data
    )

  $scope.updateUser = () ->
    User.updateUser($scope.user).then(() ->
      $scope.flash_message = 'User Information Updated.'
      window.setTimeout(() ->
        $scope.flash_message = null
        $scope.$digest()
      , 5000)
    )

  $scope.updateMember = () ->
    User.updateMember($scope.user).then(() ->
      $scope.flash_message = 'User Information Updated.'
      window.setTimeout(() ->
        $scope.flash_message = null
        $scope.$digest()
      , 5000)
    )


])
