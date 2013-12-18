Shyne.controller('ProfileCtrl', ['$scope', 'Session', 'User',($scope, Session, User) ->

  $scope.user = null
  $scope.welcomeModel = {role: null}

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
      $scope.mentorModel.location,
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


])
