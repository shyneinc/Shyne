Shyne.controller('ProfileCtrl', ['$location', '$scope','$timeout', '$routeParams', 'Session', 'User',($location, $scope, $timeout, $routeParams, Session, User) ->

  $scope.user = null
  $scope.welcomeModel = {role: null}
  $scope.resetModel = {token: null}

  $scope.refresh = (forceUpdate) ->
    Session.getCurrentUser(forceUpdate).then((user)->
      $scope.user = user
      if user.role_type is 'Member'
        User.getMemberInfo(user.role_id).then((memberInfo) ->
          angular.extend(user, memberInfo)
        )
      else if user.role_type is 'Mentor'
        User.getMentorInfo(user.role_id).then((mentorInfo) ->
          angular.extend(user, mentorInfo)
        )
    )

  $scope.refresh(false)

  $scope.showMemberForm = () ->
    $scope.welcomeModel.role = 'Member'

  $scope.showMentorForm = () ->
    $scope.welcomeModel.role = 'Mentor'

  $scope.clearRole = () ->
    $scope.welcomeModel.role = null

  $scope.becomeMember = () ->
    User.becomeMember($scope.memberModel.phoneNumber).then((data)->
     angular.extend($scope.user, data)
    , (data) ->
      $scope.memberFormError = data
    )

  $scope.becomeMentor = () ->
    User.becomeMentor(
      $scope.mentorModel.headline,
      $scope.mentorModel.city,
      $scope.mentorModel.state,
      $scope.mentorModel.experties,
      $scope.mentorModel.yearsOfExperience,
      $scope.mentorModel.phoneNumber,
      $scope.mentorModel.availability,
      $scope.mentorModel.linkedin
    ).then((data) ->
      angular.extend($scope.user, data)
    , (data) ->
      $scope.mentorFormError = data
    )

  $scope.updateUser = () ->
    User.updateUser($scope.user).then(() ->
      $scope.flash_message = 'User Information Updated.'
      window.setTimeout(() ->
        $scope.flash_message = null
        $scope.$digest()
      , 5000)
    )

  $scope.updateAvatar = (files) ->
    User.updateAvatar(files).then(() ->
      $scope.refresh(true)
      $scope.flash_message = 'User Avatar updated.'
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

  $scope.updateMentor = () ->
    User.updateMentor($scope.user).then(() ->
      $scope.flash_message = 'User Information Updated.'
      window.setTimeout(() ->
        $scope.flash_message = null
        $scope.$digest()
      , 5000)
    )

  $scope.password_reset = () ->
    User.password_reset($scope.forgotModel).then((data) ->
      $scope.flash_message = 'Email sent with password reset instructions.'
      window.setTimeout(() ->
        $scope.flash_message = null
        $scope.$digest()
      , 5000)
    , (data) ->
      $scope.resetpasswordFormError = data
    )


  $scope.changePassword = () ->
    User.changePassword($scope.resetModel).then((data) ->
      $scope.flash_message = 'Your password has been changed.'
      $timeout (->
          $scope.flash_message = null
          $location.path '/profile/'
        ), 1500
    , (data) ->
      $scope.resetpasswordFormError = data
    )

  if $routeParams.token != null
    $scope.resetModel.reset_password_token = $routeParams.token
])
